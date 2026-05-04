module RefundBackend
  module Domain
    module Errors
      class PolicyError < AppError
        def initialize(message, error_code: "UNPROCESSABLE_ENTITY")
          super(message, status: 422, error_code: error_code)
        end
      end
    end
  end
end
