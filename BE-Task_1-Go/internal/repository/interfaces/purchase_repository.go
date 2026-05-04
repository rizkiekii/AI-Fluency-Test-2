package interfaces

import (
	"context"

	"gotest/internal/domain/entities"
)

type PurchaseRepository interface {
	FindByID(ctx context.Context, purchaseID string) (entities.Purchase, bool, error)
	ListAll(ctx context.Context) ([]entities.Purchase, error)
}
