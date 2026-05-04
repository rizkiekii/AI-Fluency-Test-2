<?php

declare(strict_types=1);

namespace App\Internal\Domain\ValueObjects;

enum Region: string
{
    case US = 'US';
    case EU = 'EU';
}
