class DoAddonConnector::Digitalocean::SsoController < DoAddonConnector::ApplicationController

  def create
    @customer = DoAddonConnector::Customer.find_by(key: params[:resource_uuid])
    if @customer.present? && (resource_token == params[:token] || resource_token == params[:token])
      @sso_event = DoAddonConnector::SsoEvent.create!(
        resource_uuid: params[:resource_uuid],
        resource_token: params[:token],
        timestamp: params[:timestamp],
        email: params[:email]
      )
      
      sign_in_action if @sso_event.present?
    else
      # do not auth
      logger.info("********* Failed Login ********")
      logger.info("System Salt: #{ENV['DO_SSOSALT']}")
      logger.info("Presented Params: #{params}")
      logger.info("Presented Token: #{params[:token]}")
      logger.info("Expected Token: #{resource_token}")
      render nothing: true, status: '401'
    end
  end

  private 
  
  def resource_token
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['DO_SSOSALT'], "#{params[:timestamp]}:#{params[:resource_uuid]}")
  end

  def current_protocol
    if Rails.env == "production"
      "https"
    else
      "http"
    end
  end

end
