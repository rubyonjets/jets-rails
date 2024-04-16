require "active_job"

module Jets::Rails::Job
  class Executer
    extend Memoist

    def initialize(job_data)
      @job_data = job_data
    end

    def execute
      ActiveJob::Base.execute(@job_data)
    end
  end
end
