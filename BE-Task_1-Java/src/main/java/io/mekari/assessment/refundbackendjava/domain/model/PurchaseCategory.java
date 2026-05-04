package io.mekari.assessment.refundbackendjava.domain.model;

import com.fasterxml.jackson.annotation.JsonValue;

public enum PurchaseCategory {
    OTHER("other"),
    ELECTRONICS("electronics"),
    DIGITAL_DOWNLOAD("digital_download");

    private final String value;

    PurchaseCategory(String value) {
        this.value = value;
    }

    @JsonValue
    public String value() {
        return value;
    }
}
