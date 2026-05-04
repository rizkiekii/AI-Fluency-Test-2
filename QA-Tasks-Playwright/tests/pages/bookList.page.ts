import { type Locator, type Page, expect } from '@playwright/test';

export class BookListPage {
	// Header & navigation
	public navLink: Locator;
	public pageTitle: Locator;

	// Search
	public searchInput: Locator;
	public searchButton: Locator;
	public searchFeedback: Locator;

	// Table
	public bookTable: Locator;
	public bookIdHeader: Locator;
	public titleHeader: Locator;
	public stockHeader: Locator;
	public actionsHeader: Locator;
	public tableRows: Locator;

	// Footer
	public footer: Locator;

	constructor(public page: Page) {
		this.navLink = page.getByRole('link', { name: 'Library Management' });
		this.pageTitle = page.locator('#page-title');

		this.searchInput = page.locator('#book-search-input');
		this.searchButton = page.getByRole('button', { name: /search books/i });
		this.searchFeedback = page.locator('#book-search-feedback');

		this.bookTable = page.locator('#book-list-table');
		this.bookIdHeader = page.locator('th', { hasText: 'Book ID' });
		this.titleHeader = page.locator('th', { hasText: 'Title' });
		this.stockHeader = page.locator('th', { hasText: 'Available Stock' });
		this.actionsHeader = page.locator('th', { hasText: 'Actions' });
		this.tableRows = page.locator('table tbody tr');

		this.footer = page.locator('text=Scaffold for the Library Checkout & Return System');
	}

	async goto(): Promise<void> {
		await this.page.goto('/');
		await this.page.waitForLoadState('networkidle');
	}

	async searchFor(term: string): Promise<void> {
		await this.searchInput.fill(term);
		await this.searchButton.click();
		await this.page.waitForLoadState('networkidle');
	}

	async clearSearch(): Promise<void> {
		await this.searchInput.clear();
		await this.searchButton.click();
		await this.page.waitForLoadState('networkidle');
	}

	async getRowCount(): Promise<number> {
		return this.tableRows.count();
	}

	getBookRow(bookId: string | number): Locator {
		return this.page.locator(`#book-row_${bookId}`);
	}

	getBookStock(bookId: string | number): Locator {
		return this.page.locator(`#book-stock_${bookId}`);
	}

	async clickShowLog(bookId: string | number): Promise<void> {
		await this.page.locator(`#book-show-log_${bookId}`).click();
		await this.page.waitForLoadState('networkidle');
	}

	async clickReturn(bookId: string | number): Promise<void> {
		await this.page.locator(`#book-return_${bookId}`).click();
		await this.page.waitForLoadState('networkidle');
	}

	async clickCheckout(bookId: string | number): Promise<void> {
		await this.page.locator(`#book-checkout_${bookId}`).click();
		await this.page.waitForLoadState('networkidle');
	}

	async verifyPageLoaded(): Promise<void> {
		await expect(this.navLink).toBeVisible();
		await expect(this.pageTitle).toBeVisible();
		await expect(this.searchInput).toBeVisible();
		await expect(this.searchButton).toBeVisible();
		await expect(this.bookTable).toBeVisible();
		await expect(this.footer).toBeVisible();
	}

	async verifyTableHeaders(): Promise<void> {
		await expect(this.bookIdHeader).toBeVisible();
		await expect(this.titleHeader).toBeVisible();
		await expect(this.stockHeader).toBeVisible();
		await expect(this.actionsHeader).toBeVisible();
	}
}

