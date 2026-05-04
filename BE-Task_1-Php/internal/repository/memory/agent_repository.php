<?php

declare(strict_types=1);

namespace App\Internal\Repository\Memory;

use App\Internal\Domain\Entities\Agent;
use App\Internal\Repository\Interfaces\AgentRepositoryInterface;

final readonly class AgentRepository implements AgentRepositoryInterface
{
    public function __construct(private Store $store)
    {
    }

    public function findById(string $agentId): ?Agent
    {
        return $this->store->agents[$agentId] ?? null;
    }

    public function listAll(): array
    {
        return array_values($this->store->agents);
    }
}
