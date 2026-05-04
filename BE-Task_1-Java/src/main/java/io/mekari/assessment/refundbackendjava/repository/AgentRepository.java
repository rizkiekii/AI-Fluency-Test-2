package io.mekari.assessment.refundbackendjava.repository;

import io.mekari.assessment.refundbackendjava.domain.model.Agent;
import java.util.List;
import java.util.Optional;

public interface AgentRepository {
    Optional<Agent> findById(String agentId);

    List<Agent> listAll();
}
