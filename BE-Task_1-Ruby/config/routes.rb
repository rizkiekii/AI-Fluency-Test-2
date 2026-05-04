require_relative "../app/transport/http/router"

Rails.application.routes.draw do
  RefundBackend::Transport::Http::Router.draw(self)
end
