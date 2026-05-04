module RefundBackend
  class Application
    class Container
      attr_reader :logger, :repositories, :startup_reference, :store

      def self.build(startup_reference:)
        logger = RefundBackend::Logging::StructuredLogger.new(service_name: "refund-backend-ruby")
        store = RefundBackend::Repository::Memory::Store.new
        RefundBackend::Repository::Memory::Seed.new(store: store, startup_reference: startup_reference).call

        repositories = {
          agent: RefundBackend::Repository::Memory::AgentRepository.new(store),
          purchase: RefundBackend::Repository::Memory::PurchaseRepository.new(store),
          refund: RefundBackend::Repository::Memory::RefundRepository.new(store)
        }

        new(
          logger: logger,
          store: store,
          repositories: repositories,
          startup_reference: startup_reference
        )
      end

      def initialize(logger:, store:, repositories:, startup_reference:)
        @logger = logger
        @store = store
        @repositories = repositories
        @startup_reference = startup_reference
      end
    end
  end
end
