# app/controllers/concerns/resource_controller_extension.rb

module ResourcesControllerExtension
  extend ActiveSupport::Concern

    included do
      before_action :create_user, only: :create
    end
  
    # Account creation
    # ===========================
    # Set up the account on the vendor app here.  In the example of Devise,
    # this means creating the user that will be associated with this resource.
    # Depending on your app, you might create an account or team here instead.
    # 
    def create_user
      @account = User.new(
        email:  params[:email],
        password: Devise.friendly_token,
      )
    end
end