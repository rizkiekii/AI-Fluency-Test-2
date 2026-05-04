module RefundBackend
  module Repository
    module Memory
      class RefundRepository < RefundBackend::Repository::Interfaces::RefundRepository
        def initialize(store)
          @store = store
        end

        def create(refund)
          @store.insert_refund(refund)
        end

        def find_by_id(refund_id)
          @store.fetch_refund(refund_id)
        end

        def list_all
          @store.list_refunds
        end
      end
    end
  end
end
