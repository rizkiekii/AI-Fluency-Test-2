<?php

declare(strict_types=1);

namespace App\Internal\Domain\ValueObjects;

enum AgentRole: string
{
    case L1Support = 'L1_Support';
    case L2Support = 'L2_Support';
    case Manager = 'Manager';
}
