class DoAddonConnector::Digitalocean::SsoController < ApplicationController

  skip_before_action :verify_authenticity_token

  # DigitalOcean users of your SaaS app will need to be able to log into your dashboard. When a user wants to SSO 
  # to your service, will send the following request to your registered endpoint:

  # ```
  # // POST /digitalocean/sso
  # // Content-Type: application/x-www-form-urlencoded

  # resource_uuid=RESOURCE_UUID&resource_token=abc123abc123abc123abc123abc123&timestamp=1620912812&email=jane@example.com

  # Parameters:
  # - resource_uuid: The UUID provided by DigitalOcean during provisioning
  # - resource_token: SHA1 hash of "resource_uuid:salt:timestamp"; this is used to authnenticate the request
  # - timestamp: Unix timestamp of when the SSO request was made
  # - email: Email address of the DigitalOcean user
  # ```

  # Your service will need to validate the request by verifying the `resource_token`. This is done by creating your own SHA1 hash from `resource_uuid:salt:timestamp`. The `resource_uuid` and `timestamp` will be in the request. The `salt` was provided to you during `app` creation.

  # If the `resource_token` is valid, your app will create a session cookie for the user, and then respond with the following, allowing the user to proceed to your dashboard in a logged-in state:

  # ```json
  # // HTTP 302
  # // Location: https://www.example.com/dashboard
  # ```

  # In the event that the `resource_token` cannot be verified, respond with the following:

  # ```json
  # // HTTP 401`
  # ```

  def create

    # look up user by DO uuid
    @customer = DoAddonConnector::Customer.find_by(key: params[:resource_uuid])
    
    if @customer.present? && resource_token == params[:token] 
      @sso_event = DoAddonConnector::SsoEvent.create!(
        resource_uuid: params[:resource_uuid],
        resource_token: params[:token],
        timestamp: params[:timestamp],
        email: params[:email]
      )

      sign_in_action if @sso_event.present?
    else
      # do not auth
      # logger.info("********* Failed Login ********")
      # logger.info("System Salt: #{ENV['DO_SSOSALT']}")
      # logger.info("Presented Params: #{params}")
      # logger.info("Presented Token: #{params[:token]}")
      # logger.info("Expected Token: #{resource_token}")
      render nothing: true, status: '401'
    end
  end

  private 
  
  def resource_token
    Digest::SHA256.hexdigest("#{params[:timestamp]}:#{ENV['DO_SSOSALT']}:#{params[:resource_uuid]}")
  end

  def current_protocol
    if Rails.env == "production"
      "https"
    else
      "http"
    end
  end

end
