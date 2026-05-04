package io.mekari.assessment.refundbackendjava.repository.memory;

import io.mekari.assessment.refundbackendjava.domain.model.Agent;
import io.mekari.assessment.refundbackendjava.repository.AgentRepository;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.stereotype.Repository;

@Repository
public class InMemoryAgentRepository implements AgentRepository {
    private final Store store;

    public InMemoryAgentRepository(Store store) {
        this.store = store;
    }

    @Override
    public Optional<Agent> findById(String agentId) {
        return Optional.ofNullable(store.getAgents().get(agentId));
    }

    @Override
    public List<Agent> listAll() {
        return store.getAgents().values().stream()
            .sorted(Comparator.comparing(Agent::getAgentId))
            .collect(Collectors.toList());
    }
}
