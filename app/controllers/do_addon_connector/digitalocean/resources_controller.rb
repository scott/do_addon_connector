class DoAddonConnector::Digitalocean::ResourcesController < DoAddonConnector::Digitalocean::BaseController

  def create

    logger.info("Provisioning Request Received: \n\n #{params}")

    if @account.save

      # associate to user with Customer
      customer = DoAddonConnector::Customer.create!(
        key: params[:uuid],
        owner_id: @account.id,
        metadata: params[:metadata],
        plan: params[:plan_slug],
        email: params[:email],
        creator_uuid: params[:creator_uuid]
      )

      # Save authorization_code
      auth_code = DoAddonConnector::Token.new(
        owner_id: @account.id,
        kind: 'authorization_code',
        token: params['oauth_grant']['code'],
        expires_at: params['oauth_grant']['expires_at']
      )
      if auth_code.save
        logger.info("\nAuth Code saved!\n")
        DoAddonConnector::Token.fetch(@account.id, auth_code.id) unless Rails.env.development?
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
      errors = "#{DoAddonConnector.service_name} could not be provisioned. "
      @account.errors.messages.each do |err|
        errors += "The #{String(err[0])} #{err[1][0].downcase}. "
      end
      errors += "Please contact #{DoAddonConnector.service_name} Support. " if @account.errors.messages.length == 0
      
      render status: '422', json: { message: errors }
    end
  end

  def update
    customer = DoAddonConnector::Customer.find_by(key: params[:id])
    if customer.present?
      customer.plan = params[:plan_slug]
      if customer.save        
        response = {
          message: "Your #{DoAddonConnector.service_name} plan was changed"
        }

        render status: '200', json: response
      else
        response = {
          message: "Your #{DoAddonConnector.service_name} plan could not be changed"
        }

        render status: '422', json: response
      end
    else
      render status: '404'
    end
  end

  def destroy
    @customer = DoAddonConnector::Customer.find_by(key: params[:id])

    if @customer.present?
      token = DoAddonConnector::Token.find_by(owner_id: @customer.owner_id)
      token.destroy if token.present?
      @customer.destroy

      render status: '204', json: :ok
    else
      render status: '404'
    end
  end


  
end