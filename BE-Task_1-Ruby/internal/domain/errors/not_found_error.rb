module RefundBackend
  module Domain
    module Errors
      class NotFoundError < AppError
        def initialize(message, error_code: "NOT_FOUND")
          super(message, status: 404, error_code: error_code)
        end
      end
    end
  end
end
