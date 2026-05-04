# Ruby On Rails Refund Service

Runnable Ruby on Rails baseline for the refund backend task.

## What Is Included

- HTTP service bound to `0.0.0.0:8585`
- `GET /healthz` health endpoint
- `POST /api/v1/refunds` placeholder endpoint wired to `RefundsController#create`
- Rails API-only baseline with Puma entrypoint
- In-memory repositories with shared process-local store and startup seed data
- Structured JSON logging to `stdout` and `stderr`
- Helper scripts for normal run and log capture

## Prerequisites

- Ruby `4.0.1`
- Bundler `4.0.8` or newer

## Setup And Run

1. Install Ruby `4.0.1`.
2. Install Bundler `4.0.8` or newer.
3. Run `bundle install`.
4. Start the server with `./scripts/run.sh`.

## Run scripts

- `./scripts/run.sh`: start the server normally
- `./scripts/run_with_logs.sh`: redirect `stdout` to `logs/stdout.log` and `stderr` to `logs/stderr.log`

Health check:

```bash
curl -s http://127.0.0.1:8585/healthz
```

Expected shape:

```json
{
  "status": "ok",
  "service": "refund-backend-ruby",
  "request_id": "req_...",
  "timestamp": "2026-03-12T00:00:00Z"
}
```

## Seeded Data And Ready-To-Use Bearer Tokens

The in-memory store is re-seeded on every startup with the canonical task dataset. These agent tokens are ready to use:

| agent_id | bearer token |
| --- | --- |
| A-L1-US-001 | eyJhZ2VudF9pZCI6IkEtTDEtVVMtMDAxIn0= |
| A-L2-US-001 | eyJhZ2VudF9pZCI6IkEtTDItVVMtMDAxIn0= |
| A-MGR-US-001 | eyJhZ2VudF9pZCI6IkEtTUdSLVVTLTAwMSJ9 |
| A-L2-EU-001 | eyJhZ2VudF9pZCI6IkEtTDItRVUtMDAxIn0= |
