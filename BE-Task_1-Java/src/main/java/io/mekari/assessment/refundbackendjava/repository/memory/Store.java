package io.mekari.assessment.refundbackendjava.repository.memory;

import io.mekari.assessment.refundbackendjava.domain.model.Agent;
import io.mekari.assessment.refundbackendjava.domain.model.Purchase;
import io.mekari.assessment.refundbackendjava.domain.model.Refund;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class Store {
    private final Map<String, Agent> agents = new ConcurrentHashMap<>();
    private final Map<String, Purchase> purchases = new ConcurrentHashMap<>();
    private final Map<String, Refund> refunds = new ConcurrentHashMap<>();

    public Map<String, Agent> getAgents() {
        return agents;
    }

    public Map<String, Purchase> getPurchases() {
        return purchases;
    }

    public Map<String, Refund> getRefunds() {
        return refunds;
    }

    public void reset(
        Map<String, Agent> seededAgents,
        Map<String, Purchase> seededPurchases,
        Map<String, Refund> seededRefunds
    ) {
        agents.clear();
        agents.putAll(seededAgents);

        purchases.clear();
        purchases.putAll(seededPurchases);

        refunds.clear();
        refunds.putAll(seededRefunds);
    }
}
