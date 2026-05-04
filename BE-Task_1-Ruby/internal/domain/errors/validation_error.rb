module RefundBackend
  module Domain
    module Errors
      class ValidationError < AppError
        def initialize(message, error_code: "BAD_REQUEST")
          super(message, status: 400, error_code: error_code)
        end
      end
    end
  end
end
