class StageMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    add_stage_name(env) if on_aws?(env)
    status, headers, body = @app.call(env)
    [status, headers, body]
  end

private
  # Add API Gateway Stage Name
  def add_stage_name(env)
    # changes links that Rails generates
    env[Rack::SCRIPT_NAME] = "/#{JetsRails.stage}"
  end

  def on_aws?(env)
    return true if ENV['JETS_ON_AWS'] # for local testing
    host = env['HTTP_X_FORWARDED_HOST'] # from Jets::Rack::Request#set_headers!
    host&.include?("amazonaws.com")
  end
end
