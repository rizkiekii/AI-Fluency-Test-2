<?php

declare(strict_types=1);

namespace App\Internal\Repository\Memory;

use App\Internal\Domain\Entities\Agent;
use App\Internal\Domain\Entities\Purchase;
use App\Internal\Domain\ValueObjects\AgentRole;
use App\Internal\Domain\ValueObjects\PurchaseCategory;
use App\Internal\Domain\ValueObjects\Region;
use DateInterval;
use DateTimeImmutable;

final class Seed
{
    public static function apply(Store $store, DateTimeImmutable $startupReference): void
    {
        $agents = [
            'A-L1-US-001' => new Agent('A-L1-US-001', AgentRole::L1Support, Region::US),
            'A-L2-US-001' => new Agent('A-L2-US-001', AgentRole::L2Support, Region::US),
            'A-MGR-US-001' => new Agent('A-MGR-US-001', AgentRole::Manager, Region::US),
            'A-L2-EU-001' => new Agent('A-L2-EU-001', AgentRole::L2Support, Region::EU),
        ];

        $purchases = [
            'PUR-US-OTHER-001' => new Purchase('PUR-US-OTHER-001', Region::US, PurchaseCategory::Other, self::subtractHours($startupReference, 96)),
            'PUR-US-OTHER-002' => new Purchase('PUR-US-OTHER-002', Region::US, PurchaseCategory::Other, self::subtractHours($startupReference, 12)),
            'PUR-EU-OTHER-001' => new Purchase('PUR-EU-OTHER-001', Region::EU, PurchaseCategory::Other, self::subtractHours($startupReference, 36)),
            'PUR-US-ELEC-001' => new Purchase('PUR-US-ELEC-001', Region::US, PurchaseCategory::Electronics, self::subtractHours($startupReference, 72)),
            'PUR-US-ELEC-002' => new Purchase('PUR-US-ELEC-002', Region::US, PurchaseCategory::Electronics, self::subtractHours($startupReference, 24)),
            'PUR-US-ELEC-003' => new Purchase('PUR-US-ELEC-003', Region::US, PurchaseCategory::Electronics, self::subtractHours($startupReference, 6)),
            'PUR-EU-ELEC-001' => new Purchase('PUR-EU-ELEC-001', Region::EU, PurchaseCategory::Electronics, self::subtractHours($startupReference, 24)),
            'PUR-US-DIGI-001' => new Purchase('PUR-US-DIGI-001', Region::US, PurchaseCategory::DigitalDownload, self::subtractHours($startupReference, 6)),
            'PUR-US-DIGI-002' => new Purchase('PUR-US-DIGI-002', Region::US, PurchaseCategory::DigitalDownload, self::subtractHours($startupReference, 30)),
            'PUR-US-DIGI-003' => new Purchase('PUR-US-DIGI-003', Region::US, PurchaseCategory::DigitalDownload, self::subtractHours($startupReference, 72)),
        ];

        $store->reset($agents, $purchases, []);
    }

    private static function subtractHours(DateTimeImmutable $timestamp, int $hours): DateTimeImmutable
    {
        return $timestamp->sub(new DateInterval(sprintf('PT%dH', $hours)));
    }
}
