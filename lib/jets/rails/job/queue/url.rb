class Jets::Rails::Job::Queue
  class Url
    class << self
      extend Memoist

      def queue_url
        # On AWS Lambda JETS_JOB_QUEUE_URL will be set
        # It must be set when on AWS to avoid the API call to retrieve the queue_url
        return ENV["JETS_JOB_QUEUE_URL"] if ENV["JETS_JOB_QUEUE_URL"]

        # Locally when JETS_JOB_QUEUE_URL will try getting the latest release from API
        # 1. can be nil
        # 2. can raise NotFound error
        begin
          resp = Jets::Api::Release.retrieve("latest")
          endpoint = resp.endpoints.find { |x| x["name"] == "queue_url" }
          endpoint&.url
        rescue Jets::Api::Error::NotFound => e
          puts "WARN: Unable to get queue url from API: #{e.message}".color(:yellow)
          puts <<~EOL
            INFO: You can set JETS_JOB_QUEUE_URL in your environment to avoid this API call.
            Locally, jets will try to get the latest release from the API to get the queue_url.
            This will only work if the stack has been deployed successfully.
          EOL
          raise
        end
      end
      memoize :queue_url
    end
  end
end
