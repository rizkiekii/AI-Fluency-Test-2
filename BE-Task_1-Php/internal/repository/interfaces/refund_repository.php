<?php

declare(strict_types=1);

namespace App\Internal\Repository\Interfaces;

use App\Internal\Domain\Entities\Refund;

interface RefundRepositoryInterface
{
    public function create(Refund $refund): void;

    public function findById(string $refundId): ?Refund;

    /**
     * @return list<Refund>
     */
    public function listAll(): array;
}
