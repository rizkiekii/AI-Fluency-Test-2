module RefundBackend
  module Repository
    module Memory
      class AgentRepository < RefundBackend::Repository::Interfaces::AgentRepository
        def initialize(store)
          @store = store
        end

        def find_by_id(agent_id)
          @store.fetch_agent(agent_id)
        end

        def list_all
          @store.list_agents
        end
      end
    end
  end
end
