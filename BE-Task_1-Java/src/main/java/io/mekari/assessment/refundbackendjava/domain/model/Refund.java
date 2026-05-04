package io.mekari.assessment.refundbackendjava.domain.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

public class Refund {
    @JsonProperty("refund_id")
    private final String refundId;
    @JsonProperty("purchase_id")
    private final String purchaseId;
    @JsonProperty("agent_id")
    private final String agentId;
    private final String reason;
    private final RefundDecision decision;
    @JsonProperty("created_at")
    private final Instant createdAt;

    public Refund(
        String refundId,
        String purchaseId,
        String agentId,
        String reason,
        RefundDecision decision,
        Instant createdAt
    ) {
        this.refundId = refundId;
        this.purchaseId = purchaseId;
        this.agentId = agentId;
        this.reason = reason;
        this.decision = decision;
        this.createdAt = createdAt;
    }

    public String getRefundId() {
        return refundId;
    }

    public String getPurchaseId() {
        return purchaseId;
    }

    public String getAgentId() {
        return agentId;
    }

    public String getReason() {
        return reason;
    }

    public RefundDecision getDecision() {
        return decision;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }
}
