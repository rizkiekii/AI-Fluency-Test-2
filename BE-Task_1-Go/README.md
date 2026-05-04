# Go Refund Service

Runnable Go baseline for the refund backend task.

## What Is Included

- One long-lived HTTP service started from `cmd/api`
- `GET /healthz`
- In-memory repository implementations behind interfaces
- Canonical startup seed data loaded on every boot
- Structured JSON logging to `stdout` and `stderr`
- Helper scripts for normal run and log capture

## Prerequisites

- Go `1.25`

## Setup And Run

```bash
go run ./cmd/api
```

Or use the helper scripts from this folder:

```bash
./scripts/run.sh
./scripts/run_with_logs.sh
```

Verify the server with:

```bash
curl http://localhost:8585/healthz
```

## Seeded Data And Ready-To-Use Bearer Tokens

The in-memory store is re-seeded on every startup with the canonical task dataset. These agent tokens are ready to use:

| agent_id | bearer token |
| --- | --- |
| A-L1-US-001 | eyJhZ2VudF9pZCI6IkEtTDEtVVMtMDAxIn0= |
| A-L2-US-001 | eyJhZ2VudF9pZCI6IkEtTDItVVMtMDAxIn0= |
| A-MGR-US-001 | eyJhZ2VudF9pZCI6IkEtTUdSLVVTLTAwMSJ9 |
| A-L2-EU-001 | eyJhZ2VudF9pZCI6IkEtTDItRVUtMDAxIn0= |