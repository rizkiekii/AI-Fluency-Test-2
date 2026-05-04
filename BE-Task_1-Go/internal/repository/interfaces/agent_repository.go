package interfaces

import (
	"context"

	"gotest/internal/domain/entities"
)

type AgentRepository interface {
	FindByID(ctx context.Context, agentID string) (entities.Agent, bool, error)
	ListAll(ctx context.Context) ([]entities.Agent, error)
}
