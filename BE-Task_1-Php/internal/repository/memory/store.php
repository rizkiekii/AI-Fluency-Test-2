<?php

declare(strict_types=1);

namespace App\Internal\Repository\Memory;

use App\Internal\Domain\Entities\Agent;
use App\Internal\Domain\Entities\Purchase;
use App\Internal\Domain\Entities\Refund;

final class Store
{
    /** @var array<string, Agent> */
    public array $agents = [];

    /** @var array<string, Purchase> */
    public array $purchases = [];

    /** @var array<string, Refund> */
    public array $refunds = [];

    /**
     * @param array<string, Agent> $agents
     * @param array<string, Purchase> $purchases
     * @param array<string, Refund> $refunds
     */
    public function reset(array $agents, array $purchases, array $refunds): void
    {
        $this->agents = $agents;
        $this->purchases = $purchases;
        $this->refunds = $refunds;
    }
}
