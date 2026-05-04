<?php

declare(strict_types=1);

namespace App\Internal\Domain\Entities;

use DateTimeImmutable;

final readonly class Refund
{
    public function __construct(
        public string $refundId,
        public string $purchaseId,
        public string $agentId,
        public float $amount,
        public ?string $reason,
        public DateTimeImmutable $createdAt,
    ) {
    }

    public function toArray(): array
    {
        return [
            'refund_id' => $this->refundId,
            'purchase_id' => $this->purchaseId,
            'agent_id' => $this->agentId,
            'amount' => $this->amount,
            'reason' => $this->reason,
            'created_at' => $this->createdAt->format(DATE_ATOM),
        ];
    }
}
