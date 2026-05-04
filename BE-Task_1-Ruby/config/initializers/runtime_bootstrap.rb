Dir[File.expand_path("../../internal/**/*.rb", __dir__)].sort.each { |file| require file }

Rails.application.config.after_initialize do
  next if Rails.application.config.x.runtime.container

  container = RefundBackend::Application::Container.build(startup_reference: Time.now.utc)

  Rails.application.config.x.runtime.container = container
  Rails.application.config.x.runtime.logger = container.logger
  Rails.application.config.x.runtime.store = container.store
  Rails.application.config.x.runtime.repositories = container.repositories
end
