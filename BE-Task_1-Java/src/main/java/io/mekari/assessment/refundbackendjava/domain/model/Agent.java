package io.mekari.assessment.refundbackendjava.domain.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Agent {
    @JsonProperty("agent_id")
    private final String agentId;
    private final AgentRole role;
    private final Region region;

    public Agent(String agentId, AgentRole role, Region region) {
        this.agentId = agentId;
        this.role = role;
        this.region = region;
    }

    public String getAgentId() {
        return agentId;
    }

    public AgentRole getRole() {
        return role;
    }

    public Region getRegion() {
        return region;
    }
}
