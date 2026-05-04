package io.mekari.assessment.refundbackendjava.domain.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

public class Purchase {
    @JsonProperty("purchase_id")
    private final String purchaseId;
    private final Region region;
    private final PurchaseCategory category;
    @JsonProperty("purchase_timestamp")
    private final Instant purchaseTimestamp;

    public Purchase(String purchaseId, Region region, PurchaseCategory category, Instant purchaseTimestamp) {
        this.purchaseId = purchaseId;
        this.region = region;
        this.category = category;
        this.purchaseTimestamp = purchaseTimestamp;
    }

    public String getPurchaseId() {
        return purchaseId;
    }

    public Region getRegion() {
        return region;
    }

    public PurchaseCategory getCategory() {
        return category;
    }

    public Instant getPurchaseTimestamp() {
        return purchaseTimestamp;
    }
}
