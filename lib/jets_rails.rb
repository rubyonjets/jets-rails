require "jets_rails/railtie"
require "jets_rails/stage_name"
require "jets_rails/routing_url_for"
require "jets_rails/redirecting"

module JetsRails
  cattr_accessor :stage
  self.stage = "fake_stage"
end
