# PHP ReactPHP Refund Service

Runnable ReactPHP baseline for the refund backend task.

## What Is Included

- One long-lived HTTP service on `0.0.0.0:8585`
- `GET /healthz`
- ReactPHP wiring with PSR HTTP request and response types
- In-memory repository implementations with deterministic startup seed data
- Structured JSON logging to `stdout` and `stderr`
- Helper scripts for normal run and log capture

## Prerequisites

- PHP `8.5`
- Composer

## Setup And Run

```bash
composer install
./scripts/run.sh
```

The service listens on `0.0.0.0:8585`.

Health check:

```bash
curl http://127.0.0.1:8585/healthz
```

Optional log capture:

```bash
./scripts/run_with_logs.sh
```

This creates:

- `logs/stdout.log`
- `logs/stderr.log`

## Seeded Data And Ready-To-Use Bearer Tokens

The in-memory store is re-seeded on every startup with the canonical task dataset. These agent tokens are ready to use:

| agent_id | bearer token |
| --- | --- |
| A-L1-US-001 | eyJhZ2VudF9pZCI6IkEtTDEtVVMtMDAxIn0= |
| A-L2-US-001 | eyJhZ2VudF9pZCI6IkEtTDItVVMtMDAxIn0= |
| A-MGR-US-001 | eyJhZ2VudF9pZCI6IkEtTUdSLVVTLTAwMSJ9 |
| A-L2-EU-001 | eyJhZ2VudF9pZCI6IkEtTDItRVUtMDAxIn0= |

Tests:

```bash
vendor/bin/phpunit
```
