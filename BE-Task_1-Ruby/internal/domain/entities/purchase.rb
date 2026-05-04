module RefundBackend
  module Domain
    module Entities
      class Purchase
        attr_reader :category, :purchase_id, :purchase_timestamp, :region

        def initialize(purchase_id:, region:, category:, purchase_timestamp:)
          @purchase_id = purchase_id
          @region = region
          @category = category
          @purchase_timestamp = purchase_timestamp
          freeze
        end

        def to_h
          {
            purchase_id: purchase_id,
            region: region,
            category: category,
            purchase_timestamp: purchase_timestamp
          }
        end
      end
    end
  end
end
