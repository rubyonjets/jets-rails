require "jets_rails/railtie"
require "jets_rails/common_methods"
require "jets_rails/routing_url_for"

module JetsRails
  cattr_accessor :stage
  self.stage = "fake_stage"
end
