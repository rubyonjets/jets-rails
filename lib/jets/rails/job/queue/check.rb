class Jets::Rails::Job::Queue
  class Check
    class Error < StandardError; end

    include Jets::Util::Logging

    def initialize(job)
      @job = job
    end

    @@error_message = "ERROR: Unable to get queue url".color(:red)
    def exist!
      job_enable_message
      existance!
    end

    def queue_url
      Url.queue_url(@job.queue_name)
    end

    def existance!
      return if queue_url

      log.error @@error_message
      raise Error, "Are you sure you have deployed with Jets.project.config.job.enable = true ?"
    rescue Jets::Api::Error::NotFound
      log.error @@error_message
      raise Error, "It does not look like the stack has successfully deployed. Please deploy first."
    end

    def job_enable_message
      return if queue_url

      log.error @@error_message
      raise Error, "Are you sure that config.job.enable = true ?"
    end
  end
end
