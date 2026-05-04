class HealthController < ActionController::API
  def show
    render json: {
      status: "ok",
      service: "refund-backend-ruby",
      request_id: request.request_id,
      timestamp: Time.now.utc.iso8601
    }
  end
end
