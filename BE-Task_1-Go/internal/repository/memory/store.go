package memory

import (
	"sync"

	"gotest/internal/domain/entities"
)

type Store struct {
	mu        sync.RWMutex
	agents    map[string]entities.Agent
	purchases map[string]entities.Purchase
	refunds   map[string]entities.Refund
}

func NewStore() *Store {
	return &Store{
		agents:    make(map[string]entities.Agent),
		purchases: make(map[string]entities.Purchase),
		refunds:   make(map[string]entities.Refund),
	}
}
