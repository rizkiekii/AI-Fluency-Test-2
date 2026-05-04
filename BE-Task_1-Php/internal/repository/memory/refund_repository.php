<?php

declare(strict_types=1);

namespace App\Internal\Repository\Memory;

use App\Internal\Domain\Entities\Refund;
use App\Internal\Repository\Interfaces\RefundRepositoryInterface;

final readonly class RefundRepository implements RefundRepositoryInterface
{
    public function __construct(private Store $store)
    {
    }

    public function create(Refund $refund): void
    {
        $this->store->refunds[$refund->refundId] = $refund;
    }

    public function findById(string $refundId): ?Refund
    {
        return $this->store->refunds[$refundId] ?? null;
    }

    public function listAll(): array
    {
        return array_values($this->store->refunds);
    }
}
