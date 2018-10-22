module JetsRails::CommonMethods
  # Add API Gateway Stage Name
  def add_stage_name(url)
    return url unless on_aws?(url)

    # This gem is expected to have Jets available
    stage_name = Jets::Resource::ApiGateway::Deployment.stage_name rescue "fake_stage"
    "/#{stage_name}#{url}"
  end

  def on_aws?(url)
    return true if ENV['JETS_ON_AWS'] # for local testing
    request.host.include?("amazonaws.com") && url.starts_with?('/')
  end
end
