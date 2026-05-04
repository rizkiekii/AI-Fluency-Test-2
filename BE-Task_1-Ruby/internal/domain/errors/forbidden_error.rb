module RefundBackend
  module Domain
    module Errors
      class ForbiddenError < AppError
        def initialize(message, error_code: "FORBIDDEN")
          super(message, status: 403, error_code: error_code)
        end
      end
    end
  end
end
