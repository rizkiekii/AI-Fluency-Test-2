package memory

import (
	"context"
	"sort"

	"gotest/internal/domain/entities"
)

type AgentRepository struct {
	store *Store
}

func NewAgentRepository(store *Store) *AgentRepository {
	return &AgentRepository{store: store}
}

func (repository *AgentRepository) FindByID(_ context.Context, agentID string) (entities.Agent, bool, error) {
	repository.store.mu.RLock()
	defer repository.store.mu.RUnlock()

	agent, found := repository.store.agents[agentID]
	return agent, found, nil
}

func (repository *AgentRepository) ListAll(_ context.Context) ([]entities.Agent, error) {
	repository.store.mu.RLock()
	defer repository.store.mu.RUnlock()

	agents := make([]entities.Agent, 0, len(repository.store.agents))
	for _, agent := range repository.store.agents {
		agents = append(agents, agent)
	}

	sort.Slice(agents, func(left, right int) bool {
		return agents[left].ID < agents[right].ID
	})

	return agents, nil
}
