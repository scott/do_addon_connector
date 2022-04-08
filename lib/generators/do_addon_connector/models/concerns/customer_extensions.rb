# app/models/concerns/customer_extensions.rb

# When a resource has been successfully created, an object will be added
# to DoAddonConnector::Customers containing the resource UUID and other
# information passed through.
# 
# Define additional setup actions here that you will need after 
# the resource has been added.  Things you might do could include
# saving additional user attributes, subscribing the user to the plan
# they signed up for, or spinning up a job to create their tenancy.

module CustomerExtensions
  extend ActiveSupport::Concern

  included do
    after_create :setup_user
    after_update :change_plan
    after_destroy :destroy_user
  end

  # User Setup
  # ===========================
  # NOTE: The actual creation of the account/user on your system happens
  # in the resources_controller_extension.rb concern.
  # 
  # Add any additional user set up here, such as setting a plan
  # for the new user account.  Basically anything that should happen
  # after the initial account/user has been created.
  # 
  def setup_user
    # @u = User.find(owner_id)
    # @u.save!
  end

  # Change User Account Plan
  # ===========================
  # Add code here to change the users plan in your system. The current
  # subscribed users plan is available in the self.plan attr.
  # 
  def change_plan
    # @u = User.find(owner_id)
    # set_plan
    # @u.save!
  end

  # Destroying the User Account
  # ===========================
  # Actions to complete after a resource is deprovisioned.  You might
  # want to remove the user access, delete them, or destroy other
  # related models. In the example of using Devise, we find and destroy
  # the User.
  # 
  def destroy_user
    if owner_id.present?
      @user = User.find_by(id: owner_id) 
      @user.destroy!
    end 

    # Do some other cleanup here
  end

end
