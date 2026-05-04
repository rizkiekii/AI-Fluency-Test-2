module RefundBackend
  module Domain
    module Errors
      class UnauthorizedError < AppError
        def initialize(message = "authentication failed", error_code: "UNAUTHORIZED")
          super(message, status: 401, error_code: error_code)
        end
      end
    end
  end
end
