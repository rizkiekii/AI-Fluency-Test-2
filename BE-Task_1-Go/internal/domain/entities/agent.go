package entities

type AgentRole string

const (
	RoleL1Support AgentRole = "L1_Support"
	RoleL2Support AgentRole = "L2_Support"
	RoleManager   AgentRole = "Manager"
)

type Region string

const (
	RegionUS Region = "US"
	RegionEU Region = "EU"
)

type Agent struct {
	ID     string    `json:"agent_id"`
	Role   AgentRole `json:"role"`
	Region Region    `json:"region"`
}
