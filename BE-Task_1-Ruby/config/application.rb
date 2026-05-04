# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"

require_relative "../app/transport/http/middleware/request_context"
require_relative "../app/transport/http/middleware/error_mapping"

Bundler.require(*Rails.groups)

module RefundBackend
  class Application < Rails::Application
    config.load_defaults 8.1
    config.api_only = true
    config.autoload_paths << Rails.root.join("internal")
    config.paths.add "entrypoint", eager_load: true
    config.enable_reloading = false
    config.consider_all_requests_local = false
    config.debug_exception_response_format = :api
    config.logger = ActiveSupport::Logger.new(IO::NULL)
    config.log_level = :fatal
    config.middleware.delete Rails::Rack::Logger
    config.middleware.insert_before 0, RefundBackend::Transport::Http::Middleware::RequestContext
    config.middleware.use RefundBackend::Transport::Http::Middleware::ErrorMapping
    config.filter_parameters += %i[authorization override_token]
    config.x.runtime = ActiveSupport::InheritableOptions.new
  end
end
