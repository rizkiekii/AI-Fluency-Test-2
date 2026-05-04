module RefundBackend
  module Repository
    module Memory
      class PurchaseRepository < RefundBackend::Repository::Interfaces::PurchaseRepository
        def initialize(store)
          @store = store
        end

        def find_by_id(purchase_id)
          @store.fetch_purchase(purchase_id)
        end

        def list_all
          @store.list_purchases
        end
      end
    end
  end
end
