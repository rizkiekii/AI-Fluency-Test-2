import { type Locator, type Page, expect } from '@playwright/test';

export class BookLogPage {
	// Page elements
	public pageTitle: Locator;
	public bookId: Locator;
	public bookTitle: Locator;
	public backLink: Locator;
	public emptyState: Locator;
	public logTable: Locator;
	public logRows: Locator;

	constructor(public page: Page) {
		this.pageTitle = page.getByRole('heading', { name: 'Book Log' });
		this.bookId = page.locator('text=Book ID').locator('..').locator('div').last();
		this.bookTitle = page.locator('text=Title').locator('..').locator('div').last();
		this.backLink = page.getByRole('link', { name: /back to book list/i });
		this.emptyState = page.getByRole('status');
		this.logTable = page.locator('table');
		this.logRows = page.locator('table tbody tr');
	}

	async verifyPageLoaded(): Promise<void> {
		await expect(this.pageTitle).toBeVisible();
	}

	async verifyEmptyHistory(): Promise<void> {
		await expect(this.emptyState).toContainText(/no circulation events/i);
	}

	async verifyHasLogEntries(): Promise<void> {
		await expect(this.logRows.first()).toBeVisible();
	}

	async goBack(): Promise<void> {
		await this.backLink.click();
		await this.page.waitForLoadState('networkidle');
	}
}
