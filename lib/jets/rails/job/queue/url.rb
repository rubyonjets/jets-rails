class Jets::Rails::Job::Queue
  class Url
    class << self
      extend Memoist

      def queue_url
        # JETS_JOB_QUEUE_URL must be set when on AWS Lambda
        # to avoid the API call to retrieve the queue_url
        return ENV["JETS_JOB_QUEUE_URL"] if ENV["JETS_JOB_QUEUE_URL"]
        # 1. can be nil
        # 2. can raise NotFound error
        resp = Jets::Api::Release.retrieve("latest")
        resp.queue_url
      end
      memoize :queue_url
    end
  end
end
