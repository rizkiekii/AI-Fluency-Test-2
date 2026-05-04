package memory

import (
	"time"

	"gotest/internal/domain/entities"
)

func Seed(store *Store, startupReference time.Time) {
	startupReference = startupReference.UTC()

	store.mu.Lock()
	defer store.mu.Unlock()

	store.agents = map[string]entities.Agent{
		"A-L1-US-001":  {ID: "A-L1-US-001", Role: entities.RoleL1Support, Region: entities.RegionUS},
		"A-L2-US-001":  {ID: "A-L2-US-001", Role: entities.RoleL2Support, Region: entities.RegionUS},
		"A-MGR-US-001": {ID: "A-MGR-US-001", Role: entities.RoleManager, Region: entities.RegionUS},
		"A-L2-EU-001":  {ID: "A-L2-EU-001", Role: entities.RoleL2Support, Region: entities.RegionEU},
	}

	store.purchases = map[string]entities.Purchase{
		"PUR-US-OTHER-001": {ID: "PUR-US-OTHER-001", Region: entities.RegionUS, Category: entities.CategoryOther, PurchasedAt: startupReference.Add(-96 * time.Hour)},
		"PUR-US-OTHER-002": {ID: "PUR-US-OTHER-002", Region: entities.RegionUS, Category: entities.CategoryOther, PurchasedAt: startupReference.Add(-12 * time.Hour)},
		"PUR-EU-OTHER-001": {ID: "PUR-EU-OTHER-001", Region: entities.RegionEU, Category: entities.CategoryOther, PurchasedAt: startupReference.Add(-36 * time.Hour)},
		"PUR-US-ELEC-001":  {ID: "PUR-US-ELEC-001", Region: entities.RegionUS, Category: entities.CategoryElectronics, PurchasedAt: startupReference.Add(-72 * time.Hour)},
		"PUR-US-ELEC-002":  {ID: "PUR-US-ELEC-002", Region: entities.RegionUS, Category: entities.CategoryElectronics, PurchasedAt: startupReference.Add(-24 * time.Hour)},
		"PUR-US-ELEC-003":  {ID: "PUR-US-ELEC-003", Region: entities.RegionUS, Category: entities.CategoryElectronics, PurchasedAt: startupReference.Add(-6 * time.Hour)},
		"PUR-EU-ELEC-001":  {ID: "PUR-EU-ELEC-001", Region: entities.RegionEU, Category: entities.CategoryElectronics, PurchasedAt: startupReference.Add(-24 * time.Hour)},
		"PUR-US-DIGI-001":  {ID: "PUR-US-DIGI-001", Region: entities.RegionUS, Category: entities.CategoryDigitalDownload, PurchasedAt: startupReference.Add(-6 * time.Hour)},
		"PUR-US-DIGI-002":  {ID: "PUR-US-DIGI-002", Region: entities.RegionUS, Category: entities.CategoryDigitalDownload, PurchasedAt: startupReference.Add(-30 * time.Hour)},
		"PUR-US-DIGI-003":  {ID: "PUR-US-DIGI-003", Region: entities.RegionUS, Category: entities.CategoryDigitalDownload, PurchasedAt: startupReference.Add(-72 * time.Hour)},
	}

	store.refunds = map[string]entities.Refund{}
}
