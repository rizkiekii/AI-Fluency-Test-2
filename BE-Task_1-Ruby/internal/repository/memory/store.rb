module RefundBackend
  module Repository
    module Memory
      class Store
        def initialize
          @mutex = Mutex.new
          @agents = {}
          @purchases = {}
          @refunds = {}
        end

        def reset!(agents:, purchases:)
          @mutex.synchronize do
            @agents = agents.index_by(&:agent_id)
            @purchases = purchases.index_by(&:purchase_id)
            @refunds = {}
          end
        end

        def fetch_agent(agent_id)
          @mutex.synchronize { @agents[agent_id] }
        end

        def fetch_purchase(purchase_id)
          @mutex.synchronize { @purchases[purchase_id] }
        end

        def fetch_refund(refund_id)
          @mutex.synchronize { @refunds[refund_id] }
        end

        def insert_refund(refund)
          @mutex.synchronize do
            @refunds[refund.refund_id] = refund
            refund
          end
        end

        def list_agents
          @mutex.synchronize { @agents.values }
        end

        def list_purchases
          @mutex.synchronize { @purchases.values }
        end

        def list_refunds
          @mutex.synchronize { @refunds.values }
        end
      end
    end
  end
end
