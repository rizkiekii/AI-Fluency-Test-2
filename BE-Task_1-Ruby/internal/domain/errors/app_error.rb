module RefundBackend
  module Domain
    module Errors
      class AppError < StandardError
        attr_reader :error_code, :status

        def initialize(message, status:, error_code:)
          super(message)
          @status = status
          @error_code = error_code
        end
      end
    end
  end
end
