require 'active_support'

module JetsRails
  class Logger < ActiveSupport::Logger
    def add(severity, message = nil, progname = nil, &block)
      IO.write("/tmp/jets-output.log", message, mode: 'a')
      super
    end
  end
end
