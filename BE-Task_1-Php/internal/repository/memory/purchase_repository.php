<?php

declare(strict_types=1);

namespace App\Internal\Repository\Memory;

use App\Internal\Domain\Entities\Purchase;
use App\Internal\Repository\Interfaces\PurchaseRepositoryInterface;

final readonly class PurchaseRepository implements PurchaseRepositoryInterface
{
    public function __construct(private Store $store)
    {
    }

    public function findById(string $purchaseId): ?Purchase
    {
        return $this->store->purchases[$purchaseId] ?? null;
    }

    public function listAll(): array
    {
        return array_values($this->store->purchases);
    }
}
