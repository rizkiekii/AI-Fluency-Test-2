<?php

declare(strict_types=1);

namespace App\Internal\Application;

use App\Internal\Repository\Interfaces\AgentRepositoryInterface;
use App\Internal\Repository\Interfaces\PurchaseRepositoryInterface;
use App\Internal\Repository\Interfaces\RefundRepositoryInterface;
use DateTimeImmutable;

final readonly class HealthCheckService
{
    public function __construct(
        private array $config,
        private AgentRepositoryInterface $agents,
        private PurchaseRepositoryInterface $purchases,
        private RefundRepositoryInterface $refunds,
        private DateTimeImmutable $startupReference,
    ) {
    }

    public function status(): array
    {
        return [
            'status' => 'ok',
            'service' => $this->config['application']['service_name'],
            'version' => $this->config['application']['version'],
            'environment' => $this->config['application']['environment'],
            'startup_reference_utc' => $this->startupReference->format(DATE_ATOM),
            'seed' => [
                'agents' => count($this->agents->listAll()),
                'purchases' => count($this->purchases->listAll()),
                'refunds' => count($this->refunds->listAll()),
            ],
        ];
    }
}
