package io.mekari.assessment.refundbackendjava.domain.model;

import com.fasterxml.jackson.annotation.JsonValue;

public enum RefundDecision {
    APPROVED("approved"),
    DENIED("denied");

    private final String value;

    RefundDecision(String value) {
        this.value = value;
    }

    @JsonValue
    public String value() {
        return value;
    }
}
