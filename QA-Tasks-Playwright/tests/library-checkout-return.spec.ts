import { test, expect } from '@playwright/test';

import { resetExamTestData } from './reset-test-data';
import { BookListPage } from './pages/bookList.page';
import { CheckoutPage } from './pages/checkout.page';
import { ReturnPage } from './pages/return.page';
import { BookLogPage } from './pages/bookLog.page';

test.describe('Library Checkout & Return System', () => {
	let bookListPage: BookListPage;
	let checkoutPage: CheckoutPage;
	let returnPage: ReturnPage;
	let bookLogPage: BookLogPage;

	test.beforeEach(async ({ page, request, baseURL }) => {
		await resetExamTestData({ request, baseURL });
		bookListPage = new BookListPage(page);
		checkoutPage = new CheckoutPage(page);
		returnPage = new ReturnPage(page);
		bookLogPage = new BookLogPage(page);
	});

	// ==================== UI Functional Tests ====================

	test('TC-001: Library Books page loads with all expected elements', async () => {
		await bookListPage.goto();

		await bookListPage.verifyPageLoaded();
		await bookListPage.verifyTableHeaders();
	});

	test('TC-002: Books table displays all books with correct data', async () => {
		await bookListPage.goto();

		const rowCount = await bookListPage.getRowCount();
		expect(rowCount).toBeGreaterThan(0);

		// Verify fixture book row structure
		const stockText = await bookListPage.getBookStock(9005).textContent();
		expect(stockText).toMatch(/\d+ of \d+/);

		// Verify action links exist for a book
		const row = bookListPage.getBookRow(9005);
		await expect(row.locator('a', { hasText: /show log/i })).toBeVisible();
		await expect(row.locator('a', { hasText: /return/i })).toBeVisible();
		await expect(row.locator('a', { hasText: /checkout/i })).toBeVisible();
	});

	test('TC-003: Search books by exact title', async () => {
		await bookListPage.goto();

		await bookListPage.searchFor('Clean Code for Libraries');

		const rows = await bookListPage.getRowCount();
		expect(rows).toBe(1);
	});

	test('TC-004: Search books by book ID', async () => {
		await bookListPage.goto();

		await bookListPage.searchFor('9001');

		const rows = await bookListPage.getRowCount();
		expect(rows).toBe(1);
		await expect(bookListPage.getBookRow(9001)).toBeVisible();
	});

	test('TC-005: Search books by partial title', async () => {
		await bookListPage.goto();

		await bookListPage.searchFor('JavaScript');

		const rows = await bookListPage.getRowCount();
		expect(rows).toBeGreaterThanOrEqual(1);
	});

	test('TC-006: Search with no matching results', async ({ page }) => {
		await bookListPage.goto();

		await bookListPage.searchFor('NonExistentBookXYZ');

		const rows = await bookListPage.getRowCount();
		if (rows > 0) {
			await expect(page.locator('text=/no .*(results|books|data)/i')).toBeVisible();
		} else {
			expect(rows).toBe(0);
		}
	});

	test('TC-007: Search field clears and shows all books', async () => {
		await bookListPage.goto();

		const initialCount = await bookListPage.getRowCount();

		await bookListPage.searchFor('9001');
		const filteredCount = await bookListPage.getRowCount();
		expect(filteredCount).toBe(1);

		await bookListPage.clearSearch();

		const restoredCount = await bookListPage.getRowCount();
		expect(restoredCount).toBe(initialCount);
	});

	// ==================== Checkout Tests ====================

	test('TC-008: Checkout page loads with correct book info', async () => {
		await bookListPage.goto();
		await bookListPage.clickCheckout(9005);

		await checkoutPage.verifyPageLoaded();
		await expect(checkoutPage.availableStock).toContainText(/available/i);
		await checkoutPage.verifySubmitDisabled();
	});

	test('TC-009: Checkout a book with valid member and available stock', async () => {
		await bookListPage.goto();

		await expect(bookListPage.getBookStock(9005)).toHaveText('1 of 1');

		await bookListPage.clickCheckout(9005);
		await checkoutPage.enterMemberId('exam.checkout-ready@example.com');
		await checkoutPage.verifyBorrowerLoaded();
		await checkoutPage.verifySubmitEnabled();
		await checkoutPage.submitCheckout();

		// Navigate back to book list to verify stock decreased
		await checkoutPage.goBack();
		await expect(bookListPage.getBookStock(9005)).toHaveText('0 of 0');
	});

	test('TC-010: Checkout a book that is out of stock shows error', async ({ page }) => {
		await bookListPage.goto();

		await expect(bookListPage.getBookStock(9003)).toHaveText('0 of 0');

		await bookListPage.clickCheckout(9003);

		// Out of stock — validation banner should show and submit should be disabled
		const validationBanner = checkoutPage.page.locator('#checkout-validation-banner');
		await expect(validationBanner).toBeVisible();
		await expect(validationBanner).toContainText(/out of stock/i);
		await checkoutPage.verifySubmitDisabled();
	});

	test('TC-011: Submit Checkout button is disabled without member lookup', async () => {
		await bookListPage.goto();
		await bookListPage.clickCheckout(9005);

		await checkoutPage.verifyPageLoaded();
		await checkoutPage.verifySubmitDisabled();
	});

	// ==================== Return Tests ====================

	test('TC-012: Return page loads with correct book info', async () => {
		await bookListPage.goto();
		await bookListPage.clickReturn(9001);

		await returnPage.verifyPageLoaded();
		await returnPage.verifySubmitDisabled();
	});

	test('TC-013: Return a book that was checked out on time', async () => {
		await bookListPage.goto();

		await expect(bookListPage.getBookStock(9001)).toHaveText('0 of 0');

		await bookListPage.clickReturn(9001);
		await returnPage.enterMemberId('exam.return-on-time@example.com');
		await returnPage.verifyBorrowerLoaded();
		await returnPage.verifySubmitEnabled();

		// Overdue fine should be Rp0 for on-time return
		await returnPage.verifyOverdueFine('Rp0');
		await returnPage.submitReturn();

		// Navigate back to book list to verify stock increased
		await returnPage.goBack();
		await expect(bookListPage.getBookStock(9001)).toHaveText('1 of 1');
	});

	test('TC-014: Return a book that was checked out late shows overdue fine', async () => {
		await bookListPage.goto();
		await bookListPage.clickReturn(9002);

		await returnPage.enterMemberId('exam.return-late@example.com');
		await returnPage.verifyBorrowerLoaded();

		// Overdue fine should be greater than Rp0
		const fineText = await returnPage.overdueFine.textContent();
		expect(fineText).not.toBe('Rp0');
	});

	test('TC-015: Submit Return button is disabled without member lookup', async () => {
		await bookListPage.goto();
		await bookListPage.clickReturn(9001);

		await returnPage.verifyPageLoaded();
		await returnPage.verifySubmitDisabled();
	});

	// ==================== Book Log Tests ====================

	test('TC-016: Show Log for a book with empty history', async () => {
		await bookListPage.goto();
		await bookListPage.clickShowLog(9004);

		await bookLogPage.verifyPageLoaded();
		await bookLogPage.verifyEmptyHistory();
	});

	test('TC-017: Show Log for a book after checkout shows log entry', async () => {
		await bookListPage.goto();

		// First checkout a book
		await bookListPage.clickCheckout(9005);
		await checkoutPage.enterMemberId('exam.checkout-ready@example.com');
		await checkoutPage.verifySubmitEnabled();
		await checkoutPage.submitCheckout();

		// Navigate back to book list, then check its log
		await checkoutPage.goBack();
		await bookListPage.clickShowLog(9005);
		await bookLogPage.verifyPageLoaded();
		await bookLogPage.verifyHasLogEntries();
	});

	test('TC-018: Available stock displays correct format for all books', async () => {
		await bookListPage.goto();

		const rows = bookListPage.tableRows;
		const count = await rows.count();

		for (let i = 0; i < Math.min(count, 5); i++) {
			const stockCell = rows.nth(i).locator('td').nth(2);
			const text = await stockCell.textContent();
			expect(text).toMatch(/^\d+ of \d+$/);

			const parts = text!.split(' of ');
			const available = parseInt(parts[0]);
			const total = parseInt(parts[1]);
			expect(available).toBeLessThanOrEqual(total);
		}
	});

	test('TC-019: Large stock numbers display correctly', async () => {
		await bookListPage.goto();

		await expect(bookListPage.getBookStock(4)).toContainText('99999 of 99999');
	});

	test('TC-020: Back to Book List navigation works from all sub-pages', async () => {
		await bookListPage.goto();

		// From Checkout page
		await bookListPage.clickCheckout(9005);
		await checkoutPage.verifyPageLoaded();
		await checkoutPage.goBack();
		await bookListPage.verifyPageLoaded();

		// From Return page
		await bookListPage.clickReturn(9001);
		await returnPage.verifyPageLoaded();
		await returnPage.goBack();
		await bookListPage.verifyPageLoaded();

		// From Log page
		await bookListPage.clickShowLog(9004);
		await bookLogPage.verifyPageLoaded();
		await bookLogPage.goBack();
		await bookListPage.verifyPageLoaded();
	});

	// ==================== Security Tests ====================

	test('TC-021: XSS injection in search input is sanitized', async ({ page }) => {
		await bookListPage.goto();

		let dialogTriggered = false;
		page.on('dialog', async (dialog) => {
			dialogTriggered = true;
			await dialog.dismiss();
		});

		await bookListPage.searchFor('<script>alert("XSS")</script>');
		expect(dialogTriggered).toBe(false);

		const scriptInDOM = await page.locator('script:has-text("XSS")').count();
		expect(scriptInDOM).toBe(0);

		await bookListPage.searchFor('<img src=x onerror=alert(1)>');
		expect(dialogTriggered).toBe(false);

		const injectedImg = await page.locator('img[src="x"]').count();
		expect(injectedImg).toBe(0);

		await expect(bookListPage.searchButton).toBeVisible();
	});

	test('TC-022: SQL injection in search input is handled safely', async ({ page }) => {
		await bookListPage.goto();

		await bookListPage.searchFor("' OR '1'='1' --");

		const errorText = page.locator('text=/SQL|syntax error|database|mysql|postgres|sqlite/i');
		expect(await errorText.count()).toBe(0);

		const rows = await bookListPage.getRowCount();
		expect(rows).toBeLessThanOrEqual(1);
	});

	test('TC-023: Special characters in search do not crash application', async () => {
		await bookListPage.goto();

		const specialInputs = ['%00', '${7*7}', '{{7*7}}', '☺️📚'];
		for (const input of specialInputs) {
			await bookListPage.searchFor(input);
			await expect(bookListPage.searchButton).toBeVisible();
			// Table may be hidden when no results; verify page is still functional
			await expect(bookListPage.pageTitle).toBeVisible();
		}
	});

	test('TC-024: Excessively long search input is handled safely', async () => {
		await bookListPage.goto();

		const longInput = 'A'.repeat(10000);
		await bookListPage.searchFor(longInput);

		await expect(bookListPage.searchButton).toBeVisible();
		// Table may be hidden when no results; verify page is still functional
		await expect(bookListPage.pageTitle).toBeVisible();
	});
});
