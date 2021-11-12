DoAddonConnector.setup do |config|
  # 
  # 
  # Resource Creation
  # 
  # 
  config.source = 'digitalocean'

  # SSO Redirect
  # ======================
  # This determines where the user should be taken after a successful SSO
  config.redirect_to = 'http://localhost:3000'
end