require 'active_support'

# Tap into rails logging to show logs in CloudWatch eventually.
#
# Overriding Rails SimpleFormatter directly is pretty simple approach.
# The definition is short.
class ActiveSupport::Logger::SimpleFormatter
  # This method is invoked when a log event occurs
  def call(severity, timestamp, progname, msg)
    result = "#{String === msg ? msg : msg.inspect}\n"
    IO.write("/tmp/jets-output.log", "Rails: #{result}", mode: 'a')
    result
  end
end
