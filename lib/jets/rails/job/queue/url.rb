class Jets::Rails::Job::Queue
  class Url
    class << self
      extend Memoist

      def queue_url(queue_name)
        # On AWS Lambda JETS_QUEUE_URL must be set
        # It must be set when on AWS to avoid the API call to retrieve the queue_url
        env_var = "JETS_QUEUE_URL_#{queue_name.upcase}" # IE: JETS_QUEUE_URL_DEFAULT
        if ENV["AWS_LAMBDA_FUNCTION_NAME"]
          if ENV[env_var] # queue_url
            return ENV[env_var]
          else
            # Not never happen on AWS Lambda
            # Unless env var is removed from the lambda function
            puts <<~EOL
              WARN: JETS_QUEUE_URL_#{queue_name.upcase} not set.  Unable to get queue url.
              Maybe double check for:

              config/jets/deploy.rb

                  config.job.additional_queues = ["#{queue_name}"]

              A queue name must be defined for the SQS queue to be created.
            EOL
          end
        end

        # Locally can also be set to avoid the API call for testing
        return ENV[env_var] if ENV[env_var]

        # Only reach here locally.
        # Will try getting queue url from API latest release
        # 1. can be nil
        # 2. can raise NotFound error
        resp = Jets::Api::Release.retrieve("latest")
        endpoint = resp.endpoints.find { |x| x["name"] == "queue_url_#{queue_name}" }
        endpoint&.url
      rescue Jets::Api::Error::NotFound => e
        puts "WARN: Unable to get queue url from API: #{e.message}".color(:yellow)
        puts <<~EOL
          INFO: You can set #{env_var} in your environment to avoid this API call.
          Locally, jets will try to get the latest release from the API to get the queue_url.
          This will only work if the stack has been deployed successfully.
        EOL
        raise
      end
      memoize :queue_url
    end
  end
end
