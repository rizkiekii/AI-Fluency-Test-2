module RefundBackend
  module Repository
    module Memory
      class Seed
        def initialize(store:, startup_reference:)
          @store = store
          @startup_reference = startup_reference
        end

        def call
          @store.reset!(agents: seed_agents, purchases: seed_purchases)
        end

        private

        def seed_agents
          [
            RefundBackend::Domain::Entities::Agent.new(
              agent_id: "A-L1-US-001",
              role: RefundBackend::Domain::ValueObjects::Roles::L1_SUPPORT,
              region: RefundBackend::Domain::ValueObjects::Regions::US
            ),
            RefundBackend::Domain::Entities::Agent.new(
              agent_id: "A-L2-US-001",
              role: RefundBackend::Domain::ValueObjects::Roles::L2_SUPPORT,
              region: RefundBackend::Domain::ValueObjects::Regions::US
            ),
            RefundBackend::Domain::Entities::Agent.new(
              agent_id: "A-MGR-US-001",
              role: RefundBackend::Domain::ValueObjects::Roles::MANAGER,
              region: RefundBackend::Domain::ValueObjects::Regions::US
            ),
            RefundBackend::Domain::Entities::Agent.new(
              agent_id: "A-L2-EU-001",
              role: RefundBackend::Domain::ValueObjects::Roles::L2_SUPPORT,
              region: RefundBackend::Domain::ValueObjects::Regions::EU
            )
          ]
        end

        def seed_purchases
          [
            purchase("PUR-US-OTHER-001", "US", "other", hours_ago: 96),
            purchase("PUR-US-OTHER-002", "US", "other", hours_ago: 12),
            purchase("PUR-EU-OTHER-001", "EU", "other", hours_ago: 36),
            purchase("PUR-US-ELEC-001", "US", "electronics", hours_ago: 72),
            purchase("PUR-US-ELEC-002", "US", "electronics", hours_ago: 24),
            purchase("PUR-US-ELEC-003", "US", "electronics", hours_ago: 6),
            purchase("PUR-EU-ELEC-001", "EU", "electronics", hours_ago: 24),
            purchase("PUR-US-DIGI-001", "US", "digital_download", hours_ago: 6),
            purchase("PUR-US-DIGI-002", "US", "digital_download", hours_ago: 30),
            purchase("PUR-US-DIGI-003", "US", "digital_download", hours_ago: 72)
          ]
        end

        def purchase(purchase_id, region, category, hours_ago:)
          RefundBackend::Domain::Entities::Purchase.new(
            purchase_id: purchase_id,
            region: region,
            category: category,
            purchase_timestamp: @startup_reference - (hours_ago * 3600)
          )
        end
      end
    end
  end
end
