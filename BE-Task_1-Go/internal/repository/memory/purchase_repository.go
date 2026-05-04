package memory

import (
	"context"
	"sort"

	"gotest/internal/domain/entities"
)

type PurchaseRepository struct {
	store *Store
}

func NewPurchaseRepository(store *Store) *PurchaseRepository {
	return &PurchaseRepository{store: store}
}

func (repository *PurchaseRepository) FindByID(_ context.Context, purchaseID string) (entities.Purchase, bool, error) {
	repository.store.mu.RLock()
	defer repository.store.mu.RUnlock()

	purchase, found := repository.store.purchases[purchaseID]
	return purchase, found, nil
}

func (repository *PurchaseRepository) ListAll(_ context.Context) ([]entities.Purchase, error) {
	repository.store.mu.RLock()
	defer repository.store.mu.RUnlock()

	purchases := make([]entities.Purchase, 0, len(repository.store.purchases))
	for _, purchase := range repository.store.purchases {
		purchases = append(purchases, purchase)
	}

	sort.Slice(purchases, func(left, right int) bool {
		return purchases[left].ID < purchases[right].ID
	})

	return purchases, nil
}
