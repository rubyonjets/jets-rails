# = Configuration
#
# Configure with Rails initializer. Example:
#
# config/initializer/jets.rb:
#
#   JetsRails.stage = ENV['JETS_STAGE'] || 'dev'
#
module JetsRails
  cattr_accessor :stage
  self.stage = "dev" # default. should be set to in Rails initializer

  autoload :StageMiddleware, 'jets_rails/stage_middleware'
end

require "jets_rails/core_ext/kernel"
require "jets_rails/logger" # eager load rails override
require "jets_rails/railtie"
