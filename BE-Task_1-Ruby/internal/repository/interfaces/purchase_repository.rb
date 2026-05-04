module RefundBackend
  module Repository
    module Interfaces
      class PurchaseRepository
        def find_by_id(_purchase_id)
          raise NotImplementedError
        end

        def list_all
          raise NotImplementedError
        end
      end
    end
  end
end
