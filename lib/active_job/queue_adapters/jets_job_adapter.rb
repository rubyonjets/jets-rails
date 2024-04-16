require "active_job"

module ActiveJob::QueueAdapters
  class JetsJobAdapter
    def enqueue(job)
      Jets::Rails::Job::Queue.new(job).enqueue
    end

    def enqueue_at(job, timestamp)
      Jets::Rails::Job::Queue.new(job, timestamp).enqueue
    end
  end
end
