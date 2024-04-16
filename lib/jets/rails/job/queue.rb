require "aws-sdk-sqs"

module Jets::Rails::Job
  class Queue
    class Error < StandardError; end

    extend Memoist
    include Jets::Util::Logging
    delegate :queue_url, to: Url

    attr_reader :job, :timestamp
    def initialize(job, timestamp = nil)
      @job = job
      @timestamp = timestamp
    end

    def enqueue
      Check.exist!

      params = {
        queue_url: queue_url,
        message_body: JSON.dump(job.serialize)
      }
      if fifo?
        params.merge!(fifo_params)
      else
        params.merge!(standard_params)
      end
      log.info "Enqueueing job to #{queue_url}"
      log.debug "  with params: #{params.inspect}"
      sqs.send_message(params)
    end

    def fifo?
      queue_url.include?(".fifo")
    end

    def fifo_params
      options = {}
      options[:message_deduplication_id] = message_deduplication_id

      message_group_id = @job.message_group_id if @job.respond_to?(:message_group_id)
      message_group_id ||= "jets"

      options[:message_group_id] = message_group_id
      options
    end

    # Note that `job_id` is NOT included in deduplication keys because it is unique for
    # each initialization of the job, and the run-once behavior must be guaranteed for ActiveJob retries.
    # Even without setting job_id, it is implicitly excluded from deduplication keys.
    def message_deduplication_id
      ex_dedup_keys = @job.excluded_deduplication_keys if @job.respond_to?(:excluded_deduplication_keys)
      ex_dedup_keys ||= []
      ex_dedup_keys += ["job_id"]
      body = @job.serialize
      deduplication_body = body.except(*ex_dedup_keys)
      Digest::SHA256.hexdigest(JSON.dump(deduplication_body))
    end

    def standard_params
      @timestamp ? {delay_seconds: delay_seconds} : {}
    end

    def delay_seconds
      delay = (@timestamp - Time.now.to_f).floor
      delay = 0 if delay.negative?
      raise ArgumentError, "Unable to queue a job with a delay greater than 15 minutes" if delay > 15.minutes

      delay
    end

    def sqs
      Aws::SQS::Client.new
    end
    memoize :sqs
  end
end
