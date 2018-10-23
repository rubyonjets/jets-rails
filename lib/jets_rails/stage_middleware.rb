class StageMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    add_stage_name(env) if on_aws?
    status, headers, body = @app.call(env)
    [status, headers, body]
  end

private
  # Add API Gateway Stage Name
  def add_stage_name(env)
    # changes links that Rails generates
    env[Rack::SCRIPT_NAME] = "/#{JetsRails.stage}"
  end

  def on_aws?
    return true if ENV['JETS_ON_AWS'] # for local testing
    host = ENV['X-Forwarded-Host']
    host&.include?("amazonaws.com")
  end
end
