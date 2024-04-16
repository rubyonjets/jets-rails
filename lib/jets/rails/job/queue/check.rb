class Jets::Rails::Job::Queue
  class Check
    class Error < StandardError; end

    class << self
      include Jets::Util::Logging

      @@error_message = "ERROR: Unable to get queue url".color(:red)
      def exist!
        job_enable!
        existance!
      end

      def existance!
        return if Url.queue_url

        log.error @@error_message
        raise Error, "Are you sure you have deployed with Jets.project.config.job.enable = true ?"
      rescue Jets::Api::Error::NotFound
        log.error @@error_message
        raise Error, "It does not look like the stack has successfully deployed. Please deploy first."
      end

      def job_enable!
        return if Url.queue_url

        log.error @@error_message
        raise Error, "Are you sure that config.job.enable = true ?"
      end
    end
  end
end
