module JetsRails
  class Railtie < ::Rails::Railtie
    initializer "jets_rails.configure_rails_initialization" do
      Rails.application.middleware.insert_before(Rack::Sendfile, StageMiddleware)
    end
  end
end
