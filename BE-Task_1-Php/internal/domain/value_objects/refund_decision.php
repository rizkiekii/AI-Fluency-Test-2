<?php

declare(strict_types=1);

namespace App\Internal\Domain\ValueObjects;

enum RefundDecision: string
{
    case Approved = 'approved';
    case Rejected = 'rejected';
}
