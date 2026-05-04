import { type Locator, type Page, expect } from '@playwright/test';

export class ReturnPage {
	// Book info
	public pageTitle: Locator;
	public bookId: Locator;
	public checkoutId: Locator;
	public bookTitle: Locator;

	// Form
	public memberIdInput: Locator;
	public borrowerName: Locator;
	public borrowerPhone: Locator;
	public dueDate: Locator;
	public returnDate: Locator;
	public overdueFine: Locator;
	public alertMessage: Locator;

	// Actions
	public submitButton: Locator;
	public backLink: Locator;

	constructor(public page: Page) {
		this.pageTitle = page.getByRole('heading', { name: 'Return Book' });
		this.bookId = page.locator('dt:has-text("Book ID") + dd');
		this.checkoutId = page.locator('dt:has-text("Checkout ID") + dd');
		this.bookTitle = page.locator('dt:has-text("Title") + dd');

		this.memberIdInput = page.getByRole('textbox', { name: /library member id/i });
		this.borrowerName = page.locator('text=Borrower name').locator('..').locator('div').last();
		this.borrowerPhone = page.locator('text=Borrower phone').locator('..').locator('div').last();
		this.dueDate = page.locator('text=Due date').locator('..').locator('div').last();
		this.returnDate = page.getByRole('textbox', { name: /return date/i });
		this.overdueFine = page.locator('text=Overdue fine').locator('..').locator('div').last();
		this.alertMessage = page.locator('[role="alert"]');

		this.submitButton = page.getByRole('button', { name: /submit return/i });
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

	async submitReturn(): Promise<void> {
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

	async verifyOverdueFine(amount: string): Promise<void> {
		await expect(this.overdueFine).toContainText(amount);
	}
}

