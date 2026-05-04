module RefundBackend
  module Repository
    module Interfaces
      class AgentRepository
        def find_by_id(_agent_id)
          raise NotImplementedError
        end

        def list_all
          raise NotImplementedError
        end
      end
    end
  end
end
