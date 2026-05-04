module RefundBackend
  module Repository
    module Interfaces
      class RefundRepository
        def create(_refund)
          raise NotImplementedError
        end

        def find_by_id(_refund_id)
          raise NotImplementedError
        end

        def list_all
          raise NotImplementedError
        end
      end
    end
  end
end
