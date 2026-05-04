class RefundsController < ActionController::API
  def create
    render json: {
      error_code: "NOT_IMPLEMENTED",
      message: "refund processing is not implemented",
      request_id: request.request_id
    }, status: :not_implemented
  end
end