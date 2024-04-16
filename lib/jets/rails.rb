# frozen_string_literal: true

$:.unshift(File.expand_path("..", __dir__))
require "active_job/queue_adapters/jets_job_adapter"

require "jets/rails/autoloader"
Jets::Rails::Autoloader.setup

require "memoist"
require "rainbow/ext/string"

module Jets
  module Rails
    class Error < StandardError; end
  end
end

require "jets/rails/engine" if defined?(Rails::Railtie)
