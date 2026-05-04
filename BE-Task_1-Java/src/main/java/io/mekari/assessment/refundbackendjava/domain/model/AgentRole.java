package io.mekari.assessment.refundbackendjava.domain.model;

import com.fasterxml.jackson.annotation.JsonValue;

public enum AgentRole {
    L1_SUPPORT("L1_Support"),
    L2_SUPPORT("L2_Support"),
    MANAGER("Manager");

    private final String value;

    AgentRole(String value) {
        this.value = value;
    }

    @JsonValue
    public String value() {
        return value;
    }
}
