require 'active_support'

# Override Rails SimpleFormatter directly is pretty simple approach here.
# The definition is short.
class ActiveSupport::Logger::SimpleFormatter
  # This method is invoked when a log event occurs
  def call(severity, timestamp, progname, msg)
    result = "#{String === msg ? msg : msg.inspect}\n"
    IO.write("/tmp/jets-output.log", "Rails: #{result}", mode: 'a')
    result
  end
end
