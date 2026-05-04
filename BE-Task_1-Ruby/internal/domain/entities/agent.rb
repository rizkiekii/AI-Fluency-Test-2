module RefundBackend
  module Domain
    module Entities
      class Agent
        attr_reader :agent_id, :region, :role

        def initialize(agent_id:, role:, region:)
          @agent_id = agent_id
          @role = role
          @region = region
          freeze
        end

        def to_h
          {
            agent_id: agent_id,
            role: role,
            region: region
          }
        end
      end
    end
  end
end
