package entities

import "time"

type PurchaseCategory string

const (
	CategoryOther           PurchaseCategory = "other"
	CategoryElectronics     PurchaseCategory = "electronics"
	CategoryDigitalDownload PurchaseCategory = "digital_download"
)

type Purchase struct {
	ID          string           `json:"purchase_id"`
	Region      Region           `json:"region"`
	Category    PurchaseCategory `json:"category"`
	PurchasedAt time.Time        `json:"purchase_timestamp"`
}
