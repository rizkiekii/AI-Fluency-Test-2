module RefundBackend
  module Domain
    module Entities
      class Refund
        attr_reader :approved_by_role, :created_at, :decision, :override_applied,
                    :processed_amount, :purchase_category, :purchase_id, :refund_id,
                    :requested_amount, :restocking_fee_amount, :status

        def initialize(refund_id:, purchase_id:, purchase_category:, decision:, requested_amount:, processed_amount:,
                       restocking_fee_amount:, override_applied:, approved_by_role:, status:, created_at:)
          @refund_id = refund_id
          @purchase_id = purchase_id
          @purchase_category = purchase_category
          @decision = decision
          @requested_amount = requested_amount
          @processed_amount = processed_amount
          @restocking_fee_amount = restocking_fee_amount
          @override_applied = override_applied
          @approved_by_role = approved_by_role
          @status = status
          @created_at = created_at
          freeze
        end

        def to_h
          {
            refund_id: refund_id,
            purchase_id: purchase_id,
            purchase_category: purchase_category,
            decision: decision,
            requested_amount: requested_amount,
            processed_amount: processed_amount,
            restocking_fee_amount: restocking_fee_amount,
            override_applied: override_applied,
            approved_by_role: approved_by_role,
            status: status,
            created_at: created_at
          }
        end
      end
    end
  end
end
