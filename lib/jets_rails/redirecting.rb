module JetsRails
  module Redirecting
    include JetsRails::StageName

    def redirect_to(options = {}, response_status = {})
      super
      location = self.location
      location = _jets_update_location(location)
      self.location = location
    end

    def _jets_update_location(location)
      location = add_stage_name(location)
      scheme = request.headers['X-Forwarded-Proto'] || 'http'
      host = request.headers['X-Forwarded-Host'] || request.host # locally with rack it uses request.host
      port = request.headers['X-Forwarded-Port'] || 80
      path = request.headers['REQUEST_PATH']
      host_with_port = if port.nil? || port == 80
        host
      else
        "#{host}:#{port}"
      end
      location = "#{scheme}://#{host_with_port}#{path}"
    end
  end
end

ActionController::Base.send(:include, JetsRails::Redirecting)
