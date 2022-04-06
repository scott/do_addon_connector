class DoAddonConnector::Digitalocean::SsoController < DoAddonConnector::ApplicationController

  def create
    @customer = DoAddonConnector::Customer.find_by(key: params[:resource_uuid])
    if @customer.present? && resource_token == params[:token] && !token_expired?
      @sso_event = DoAddonConnector::SsoEvent.create!(
        resource_uuid: params[:resource_uuid],
        resource_token: params[:token],
        timestamp: params[:timestamp],
        email: params[:user_email],
        user_id: params[:user_id],
        owner_id: @customer.id
      )
      logger.info("********* Successful Login ********")
      sign_in_action if @sso_event.present?
    else
      # do not auth
      logger.info("********* Failed Login ********")
      logger.info("System Salt: #{DoAddonConnector.salt}")
      logger.info("Presented Params: #{params}")
      logger.info("Presented Token: #{params[:token]}")
      logger.info("Expected Token: #{resource_token}")
      logger.info("Timestamp: #{params[:timestamp]}")
      logger.info("Token Expired: #{token_expired?}")
      render nothing: true, status: '401'
    end
  end

  private 
  
  def resource_token
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), DoAddonConnector.salt, "#{params[:timestamp]}:#{params[:resource_uuid]}")
  end

  def token_expired?
    Time.now.to_i - params[:timestamp].to_i > DoAddonConnector.token_expires_in
  end

  def current_protocol
    if Rails.env == "production"
      "https"
    else
      "http"
    end
  end

end
