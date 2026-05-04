package memory

import (
	"context"
	"fmt"
	"sort"

	"gotest/internal/domain/entities"
)

type RefundRepository struct {
	store *Store
}

func NewRefundRepository(store *Store) *RefundRepository {
	return &RefundRepository{store: store}
}

func (repository *RefundRepository) Create(_ context.Context, refund entities.Refund) error {
	repository.store.mu.Lock()
	defer repository.store.mu.Unlock()

	if _, exists := repository.store.refunds[refund.ID]; exists {
		return fmt.Errorf("refund with id %s already exists", refund.ID)
	}

	repository.store.refunds[refund.ID] = refund
	return nil
}

func (repository *RefundRepository) FindByID(_ context.Context, refundID string) (entities.Refund, bool, error) {
	repository.store.mu.RLock()
	defer repository.store.mu.RUnlock()

	refund, found := repository.store.refunds[refundID]
	return refund, found, nil
}

func (repository *RefundRepository) ListAll(_ context.Context) ([]entities.Refund, error) {
	repository.store.mu.RLock()
	defer repository.store.mu.RUnlock()

	refunds := make([]entities.Refund, 0, len(repository.store.refunds))
	for _, refund := range repository.store.refunds {
		refunds = append(refunds, refund)
	}

	sort.Slice(refunds, func(left, right int) bool {
		return refunds[left].ID < refunds[right].ID
	})

	return refunds, nil
}
