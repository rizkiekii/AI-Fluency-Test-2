<?php

declare(strict_types=1);

namespace App\Internal\Repository\Interfaces;

use App\Internal\Domain\Entities\Agent;

interface AgentRepositoryInterface
{
    public function findById(string $agentId): ?Agent;

    /**
     * @return list<Agent>
     */
    public function listAll(): array;
}
