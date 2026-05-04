package entities

import "time"

type RefundDecision string

const (
	DecisionApproved RefundDecision = "approved"
	DecisionDenied   RefundDecision = "denied"
)

type Refund struct {
	ID         string         `json:"refund_id"`
	PurchaseID string         `json:"purchase_id"`
	AgentID    string         `json:"agent_id"`
	Reason     string         `json:"reason"`
	Decision   RefundDecision `json:"decision"`
	CreatedAt  time.Time      `json:"created_at"`
}
