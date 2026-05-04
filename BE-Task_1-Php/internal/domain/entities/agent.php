<?php

declare(strict_types=1);

namespace App\Internal\Domain\Entities;

use App\Internal\Domain\ValueObjects\AgentRole;
use App\Internal\Domain\ValueObjects\Region;

final readonly class Agent
{
    public function __construct(
        public string $agentId,
        public AgentRole $role,
        public Region $region,
    ) {
    }

    public function toArray(): array
    {
        return [
            'agent_id' => $this->agentId,
            'role' => $this->role->value,
            'region' => $this->region->value,
        ];
    }
}
