<?php

declare(strict_types=1);

namespace App\Internal\Domain\Entities;

use App\Internal\Domain\ValueObjects\PurchaseCategory;
use App\Internal\Domain\ValueObjects\Region;
use DateTimeImmutable;

final readonly class Purchase
{
    public function __construct(
        public string $purchaseId,
        public Region $region,
        public PurchaseCategory $category,
        public DateTimeImmutable $purchaseTimestamp,
    ) {
    }

    public function toArray(): array
    {
        return [
            'purchase_id' => $this->purchaseId,
            'region' => $this->region->value,
            'category' => $this->category->value,
            'purchase_timestamp' => $this->purchaseTimestamp->format(DATE_ATOM),
        ];
    }
}
