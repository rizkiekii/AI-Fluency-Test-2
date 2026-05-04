import { type Locator, type Page, expect } from '@playwright/test';

export class CheckoutPage {
	// Book info
	public pageTitle: Locator;
	public bookId: Locator;
	public bookTitle: Locator;
	public availableStock: Locator;

	// Form
	public memberIdInput: Locator;
	public borrowerName: Locator;
	public borrowerPhone: Locator;
	public checkoutDate: Locator;
	public dueDate: Locator;
	public alertMessage: Locator;

	// Actions
	public submitButton: Locator;
	public backLink: Locator;

	constructor(public page: Page) {
		this.pageTitle = page.getByRole('heading', { name: 'Checkout Book' });
		this.bookId = page.locator('dt:has-text("Book ID") + dd');
		this.bookTitle = page.locator('dt:has-text("Title") + dd');
		this.availableStock = page.locator('dt:has-text("Available stock") + dd');

		this.memberIdInput = page.getByRole('textbox', { name: /library member id/i });
		this.borrowerName = page.locator('text=Borrower name').locator('..').locator('div').last();
		this.borrowerPhone = page.locator('text=Borrower phone').locator('..').locator('div').last();
		this.checkoutDate = page.getByRole('textbox', { name: /checkout date/i });
		this.dueDate = page.locator('text=Due date').locator('..').locator('div').last();
		this.alertMessage = page.locator('[role="alert"]');

		this.submitButton = page.getByRole('button', { name: /submit checkout/i });
		this.backLink = page.getByRole('link', { name: /back to book list/i }).first();
	}

	async verifyPageLoaded(): Promise<void> {
		await expect(this.pageTitle).toBeVisible();
		await expect(this.memberIdInput).toBeVisible();
		await expect(this.submitButton).toBeVisible();
	}

	async enterMemberId(email: string): Promise<void> {
		await this.memberIdInput.fill(email);
		await this.memberIdInput.press('Tab');
		await this.page.waitForLoadState('networkidle');
	}

	async submitCheckout(): Promise<void> {
		await this.submitButton.click();
		await this.page.waitForLoadState('networkidle');
	}

	async goBack(): Promise<void> {
		await this.backLink.click();
		await this.page.waitForLoadState('networkidle');
	}

	async verifySubmitDisabled(): Promise<void> {
		await expect(this.submitButton).toBeDisabled();
	}

	async verifySubmitEnabled(): Promise<void> {
		await expect(this.submitButton).toBeEnabled();
	}

	async verifyBorrowerLoaded(): Promise<void> {
		await expect(this.borrowerName).not.toHaveText(/not loaded/i);
		await expect(this.borrowerPhone).not.toHaveText(/not loaded/i);
	}
}

