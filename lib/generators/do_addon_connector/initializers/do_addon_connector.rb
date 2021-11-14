DoAddonConnector.setup do |config|
  # 
  # Service Name
  # ======================
  # This is the name of the parent service
  config.service_name = "Scrubl"

  # App Slug
  # ======================
  # This is the slug used by your app
  config.slug = "acme" #"scrubl-staging"

  # Source
  # ======================
  # This represents the source of the user
  config.source = 'digitalocean'

  # SSO Redirect
  # ======================
  # This determines where the user should be taken after a successful SSO
  config.redirect_to = 'https://scrubl.com/dashboard'
end


# config/initializers/customer_extensions.rb
Rails.application.config.to_prepare do
  DoAddonConnector::Customer.include CustomerExtensions
end

# config/initializers/sso_login_extensions.rb
Rails.application.config.to_prepare do  
  DoAddonConnector::Digitalocean::SsoController.include SsoLoginExtension
end

# config/initializers/sso_login_extensions.rb
Rails.application.config.to_prepare do  
  DoAddonConnector::Digitalocean::ResourcesController.include ResourcesControllerExtension
end