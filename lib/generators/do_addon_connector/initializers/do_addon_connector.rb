DoAddonConnector.setup do |config|
  # 
  # Service Name
  # ======================
  # This is the name of the parent service
  config.service_name = "Application"

  # App Slug
  # ======================
  # This is the slug used by your app
  config.slug = "acme"

  # Password
  # ======================
  # This is the password assigned to your resource
  config.password = "password" 

  # Salt
  # ======================
  # This is the salt assigned to your resource
  config.salt = "sso_salt"
  
  # Secret
  # ======================
  # This is the client secret assigned to your resource
  config.secret = "do_secret"

  # Token Expiration
  # ======================
  # This is how long in seconds before the token is expired
  config.token_expires_in = 120

  # Source
  # ======================
  # This represents the source of the user
  config.source = 'digitalocean'

  # SSO Redirect
  # ======================
  # This determines where the user should be taken after a successful SSO
  config.redirect_to = 'https://your-app.com/dashboard'

  # Debug
  # ======================
  # Logs additional information and stores SSO tokens for later inspection
  config.debug = false

end


# config/initializers/customer_extensions.rb
Rails.application.config.to_prepare do
  DoAddonConnector::Customer.include CustomerExtensions
end

# config/initializers/sso_login_extensions.rb
Rails.application.config.to_prepare do  
  DoAddonConnector::Digitalocean::SsoController.include SsoLoginExtension
end

# config/initializers/notifications_controller_extension.rb
Rails.application.config.to_prepare do  
  DoAddonConnector::Digitalocean::NotificationsController.include NotificationsControllerExtension
end

# config/initializers/resources_controller_extension.rb
Rails.application.config.to_prepare do  
  DoAddonConnector::Digitalocean::ResourcesController.include ResourcesControllerExtension
end