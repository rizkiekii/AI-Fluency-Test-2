module RefundBackend
  module Transport
    module Http
      class Router
        def self.draw(mapper)
          mapper.get "/healthz", to: "health#show"
          mapper.post "/api/v1/refunds", to: "refunds#create"
        end
      end
    end
  end
end
