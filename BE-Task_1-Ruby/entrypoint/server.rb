#!/usr/bin/env ruby
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
ENV["HOST"] ||= "0.0.0.0"
ENV["PORT"] ||= "8585"
ENV["RAILS_ENV"] ||= "development"

require_relative "../config/environment"

root = File.expand_path("..", __dir__)
logger = Rails.application.config.x.runtime.logger
logger.info(
  event: RefundBackend::Logging::Events::SERVER_STARTING,
  host: ENV["HOST"],
  port: ENV["PORT"].to_i,
  rails_env: ENV["RAILS_ENV"]
)

command = [
  "bundle",
  "exec",
  "puma",
  "-q",
  "-C",
  File.join(root, "config", "puma.rb"),
  File.join(root, "config.ru")
]

child_pid = spawn(*command, chdir: root)

forward = lambda do |signal|
  begin
    Process.kill(signal, child_pid)
  rescue Errno::ESRCH
    nil
  end
end

Signal.trap("INT") { forward.call("INT") }
Signal.trap("TERM") { forward.call("TERM") }

_, status = Process.wait2(child_pid)

logger.info(
  event: RefundBackend::Logging::Events::SERVER_STOPPED,
  exit_status: status.exitstatus,
  signal: status.termsig
)

exit(status.exitstatus || 0)
