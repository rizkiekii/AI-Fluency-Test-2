<?php

declare(strict_types=1);

namespace App\Internal\Repository\Interfaces;

use App\Internal\Domain\Entities\Purchase;

interface PurchaseRepositoryInterface
{
    public function findById(string $purchaseId): ?Purchase;

    /**
     * @return list<Purchase>
     */
    public function listAll(): array;
}
