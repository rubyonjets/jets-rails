# JETS_MEGA is set in the bin/rackup wrapper
# We do this check so we can include jets-rails in the Gemfile and allow users
# to check to see if the bundle install will work though this is not activated
# logically without JETS_MEGA set.
return unless ENV['JETS_MEGA']

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
