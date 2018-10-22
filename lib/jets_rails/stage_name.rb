module JetsRails::StageName
  # Add API Gateway Stage Name
  def add_stage_name(url)
    return url unless on_aws?(url)
    "/#{JetsRails.stage}#{url}"
  end

  def on_aws?(url)
    puts "request.host: #{request.host.inspect}"
    puts "JETS_ON_AWS #{ENV['JETS_ON_AWS'].inspect}"

    return true if ENV['JETS_ON_AWS'] # for local testing
    request.host.include?("amazonaws.com") && url.starts_with?('/')
  end
end
