import { existsSync } from 'node:fs';
import { defineConfig, devices } from '@playwright/test';

const chromeExecutablePath = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const hasChromeChannel = existsSync(chromeExecutablePath);

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  timeout: 30_000,
  expect: {
    timeout: 5_000,
  },
  reporter: [['list']],
  use: {
    ...devices['Desktop Chrome'],
    baseURL: 'http://127.0.0.1:8585',
    headless: true,
    acceptDownloads: true,
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  webServer: {
    command: 'npm run dev',
    url: 'http://127.0.0.1:8585',
    reuseExistingServer: true,
    timeout: 120_000,
  },
  projects: [
    {
      name: 'chrome-headless',
      use: {
        browserName: 'chromium',
        channel: hasChromeChannel ? 'chrome' : undefined,
      },
    },
  ],
});