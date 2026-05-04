package io.mekari.assessment.refundbackendjava.repository.memory;

import io.mekari.assessment.refundbackendjava.domain.model.Agent;
import io.mekari.assessment.refundbackendjava.domain.model.AgentRole;
import io.mekari.assessment.refundbackendjava.domain.model.Purchase;
import io.mekari.assessment.refundbackendjava.domain.model.PurchaseCategory;
import io.mekari.assessment.refundbackendjava.domain.model.Region;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Map;

public final class Seed {
    private Seed() {
    }

    public static void apply(Store store, Instant startupReference) {
        Instant reference = startupReference.truncatedTo(ChronoUnit.MILLIS);

        Map<String, Agent> agents = Map.of(
            "A-L1-US-001", new Agent("A-L1-US-001", AgentRole.L1_SUPPORT, Region.US),
            "A-L2-US-001", new Agent("A-L2-US-001", AgentRole.L2_SUPPORT, Region.US),
            "A-MGR-US-001", new Agent("A-MGR-US-001", AgentRole.MANAGER, Region.US),
            "A-L2-EU-001", new Agent("A-L2-EU-001", AgentRole.L2_SUPPORT, Region.EU)
        );

        Map<String, Purchase> purchases = Map.ofEntries(
            Map.entry("PUR-US-OTHER-001", new Purchase("PUR-US-OTHER-001", Region.US, PurchaseCategory.OTHER, reference.minus(96, ChronoUnit.HOURS))),
            Map.entry("PUR-US-OTHER-002", new Purchase("PUR-US-OTHER-002", Region.US, PurchaseCategory.OTHER, reference.minus(12, ChronoUnit.HOURS))),
            Map.entry("PUR-EU-OTHER-001", new Purchase("PUR-EU-OTHER-001", Region.EU, PurchaseCategory.OTHER, reference.minus(36, ChronoUnit.HOURS))),
            Map.entry("PUR-US-ELEC-001", new Purchase("PUR-US-ELEC-001", Region.US, PurchaseCategory.ELECTRONICS, reference.minus(72, ChronoUnit.HOURS))),
            Map.entry("PUR-US-ELEC-002", new Purchase("PUR-US-ELEC-002", Region.US, PurchaseCategory.ELECTRONICS, reference.minus(24, ChronoUnit.HOURS))),
            Map.entry("PUR-US-ELEC-003", new Purchase("PUR-US-ELEC-003", Region.US, PurchaseCategory.ELECTRONICS, reference.minus(6, ChronoUnit.HOURS))),
            Map.entry("PUR-EU-ELEC-001", new Purchase("PUR-EU-ELEC-001", Region.EU, PurchaseCategory.ELECTRONICS, reference.minus(24, ChronoUnit.HOURS))),
            Map.entry("PUR-US-DIGI-001", new Purchase("PUR-US-DIGI-001", Region.US, PurchaseCategory.DIGITAL_DOWNLOAD, reference.minus(6, ChronoUnit.HOURS))),
            Map.entry("PUR-US-DIGI-002", new Purchase("PUR-US-DIGI-002", Region.US, PurchaseCategory.DIGITAL_DOWNLOAD, reference.minus(30, ChronoUnit.HOURS))),
            Map.entry("PUR-US-DIGI-003", new Purchase("PUR-US-DIGI-003", Region.US, PurchaseCategory.DIGITAL_DOWNLOAD, reference.minus(72, ChronoUnit.HOURS)))
        );

        store.reset(agents, purchases, Map.of());
    }
}
