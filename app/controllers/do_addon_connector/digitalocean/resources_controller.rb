class DoAddonConnector::Digitalocean::ResourcesController < DoAddonConnector::Digitalocean::BaseController

  skip_before_action :verify_authenticity_token

  # // POST /digitalocean/resources
  # // Content-Type: application/json
  # // Authorization: Basic YWNtZToxMjM0

  # {
  # 	"app_slug": "example", // User selected app slug as provided by the vendor during vendor registration
  #   "plan_slug": "premium", // User selected plan slug as provided by the vendor during vendor registration
  #   "uuid": "RESOURCE_UUID", // DO generated UUID for identifying this specific resource
  # 	"callback_url": "https://api.digitalocean.com/v2/saas/RESOURCE_UUID", // Not in use yet: will be used for async provisioning
  # 	"options": { "region": "eu", "foo": "bar" }, // customizable metadata that a DigitalOcean user can set for this specific app
  # 	"oauth_grant": { // You'll need to asynchronously exchange this authorization_code for an access_token and refresh_token upon success. With the access_token, you can modify this specific resource within DO.
  # 		"type": "authorization_code",
  # 		"code": "AUTHORIZATION_CODE_UUID",
  # 		"expires_at": 1620915831
  # 	}
  # }

  def create

    logger.info("Provisioning Request Received: \n\n #{params}")
    @user = User.new(
      email: email,
      source: DoAddonConnector.source,
      password: password
    )

    if @user.save
      logger.info("User saved\n")

      # associate to user with Customer
      customer = DoAddonConnector::Customer.create!(
        user_id: @user.id,
        key: params[:uuid],
        metadata: params[:metadata],
        plan: params[:plan_slug],
        email: params[:email],
        creator_uuid: params[:creator_uuid]
      )

      # Save authorization_code
      auth_code = DoAddonConnector::Token.new(
        user_id: @user.id,
        kind: 'authorization_code',
        token: params['oauth_grant']['code'],
        expires_at: params['oauth_grant']['expires_at']
      )
      if auth_code.save
        logger.info("\nAuth Code saved!\n")
        DoAddonConnector::Token.fetch(@user.id, auth_code.id) unless Rails.env.development?
      end

      # Your app will then respond with the following:
      # // HTTP 201

      # {
      #   "id": "RESOURCE_UUID", // required: An immutable value for DO to reference this resource within your app. Can be the UUID from the originating request.
      #   "config": { // the variables necessary to enable the DO user to utilize your app (endpoints, credentials, etc). The variables will be prefixed with your app's slug (even if you don't specify it).
      # 		"EXAMPLE_ENDPOINT": "https://do-user:password@api.example.com/v1",
      # 		"EXAMPLE_FOO": "BAR"
      #   },
      #   "message": "A message that will be displayed to the DO user upon completion of the request." // optional
      # }

      response = {
        id: customer.id,
        config: {
        },
        message: "#{DoAddonConnector.service_name} Account created successfully"
      }

      render status: '201', json: response.to_json

    else
      # In the event that the resource cannot be created, respond with the following:

      # // HTTP 422

      # {
      # 	"message": "A message that will be displayed to the DO user as to why the resource could not be created." // optional
      # }
      errors = "#{DoAddonConnector.service_name} could not be provisioned. "
      @user.errors.messages.each do |err|
        errors += "The #{String(err[0])} #{err[1][0].downcase}. "
      end
      errors += "Please contact #{DoAddonConnector.service_name} Support. " if @user.errors.messages.length == 0
      
      render status: '422', json: { message: errors }

    end
  end

  # // PUT /digitalocean/resources/:resource_uuid
  # // Content-Type: application/json
  # // Authorization: Basic YWNtZToxMjM0

  # {
  # 	"plan_slug": "newly-selected-plan"
  # }

  def update
    customer = DoAddonConnector::Customer.find_by(key: params[:id])
    if customer.present?
      customer.plan = params[:plan_slug]
      if customer.save
        # Your app will then respond with the following:

        # // HTTP 200

        # {
        # 	"message": "A message that will be displayed to the DO user upon completion of the request." // optional
        # }
        # 
        
        response = {
          message: "Your #{DoAddonConnector.service_name} plan was changed"
        }

        render status: '200', json: response
      else
        # In the event that the plan cannot be changed, respond with the following:

        # // HTTP 422

        # {
        # 	"message": "A message that will be displayed to the DO user as to why the plan couldn't be changed." // optional
        # }

        response = {
          message: "Your #{DoAddonConnector.service_name} plan could not be changed"
        }

        render status: '422', json: response
      end
    else
      # In the event that the resource cannot be found, respond with the following:

      # // HTTP 404

      render status: '404'
    end
  end

  # // DELETE /digitalocean/resources/:resource_uuid
  # // Content-Type: application/json
  # // Authorization: Basic YWNtZToxMjM0

  # {}
  def destroy
    customer = DoAddonConnector::Customer.find_by(key: params[:id])
    @user = User.find_by(id: customer.user_id)

    if @user.present?
      DoAddonConnector::Token.find_by(user_id: customer.user_id).destroy
      @user.destroy!
      customer.destroy!

      render status: '204', json: :ok
    else
      render status: '404'
    end
  end

  private
  
  def email
    params[:email].present? ? params[:email] : 'firstuser@yoursite.com'
  end

  def password
    if params[:metadata].present? && params[:metadata][:password].present?
       params[:metadata][:password] 
    else 
      Devise.friendly_token
    end    
  end
  
end