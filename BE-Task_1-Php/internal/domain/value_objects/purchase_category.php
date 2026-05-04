<?php

declare(strict_types=1);

namespace App\Internal\Domain\ValueObjects;

enum PurchaseCategory: string
{
    case Other = 'other';
    case Electronics = 'electronics';
    case DigitalDownload = 'digital_download';
}
