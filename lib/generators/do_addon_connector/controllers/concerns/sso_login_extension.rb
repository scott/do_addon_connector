# app/controllers/concerns/sso_login_extensions.rb

module SsoLoginExtension
  extend ActiveSupport::Concern

  # 
  # This is where we actually define how to sign the user in.
  # We get here if the SSO event was persisted
  # 
  def sign_in_action
          
    # Here we get the owner/user for this account as mapped by the resource_id
    # and sign them in using Devise.

    # owner_id = DoAddonConnector::Customer.find_by(resource_uuid: @sso_event.resource_uuid).user_id
    user = User.find(@customer.owner_id)

    sign_in(user)
    redirect_to DoAddonConnector.redirect_to 
  end
end