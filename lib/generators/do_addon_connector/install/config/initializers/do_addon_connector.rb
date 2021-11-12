DoAddonConnector.setup do |config|
  # 
  # Service Name
  # ======================
  # This is the name of the parent service
  config.service_name = "Scrubl"

  # Source
  # ======================
  # This represents the source of the user
  config.source = 'digitalocean'

  # SSO Redirect
  # ======================
  # This determines where the user should be taken after a successful SSO
  config.redirect_to = 'http://localhost:3000'
end