class DoAddonConnector::Digitalocean::BaseController < DoAddonConnector::ApplicationController

  before_action :authenticate

  # 
  # When DigitalOcean makes API requests to your app's endpoints, we will utilize basic auth. 
  # The auth header will contain a base64 encoded string consisting of your app's `slug` and the 
  # pre-shared `password` in the format: `slug:password`. For example, an app whose slug is `acme` 
  # and password is `1234` will receive requests with the following 
  # authorization header: `Authorization: Basic YWNtZToxMjM0`.
  # 
  # 
  def authenticate
    authenticate_or_request_with_http_basic('Basic') do |name, password|
      name == DoAddonConnector.slug && password == "#{DoAddonConnector.password}"
    end
  end

end
