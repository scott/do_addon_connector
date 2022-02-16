# app/controllers/concerns/notifications_controller_extension.rb

module NotificationsControllerExtension
  extend ActiveSupport::Concern

    included do
      after_action :respond_to_webhook, only: :create
    end
  
    # Webhook Notifications
    # ===========================
    # Notifications are sent to your app in the form of webhooks.  Each webhook will
    # describe specific behavior.  Currently this includes the following:
    # 
    # resources.suspended - this webhook is sent when an end user fails to pay
    # 
    # resources.reactivated - this webhook is sent when an end user resumes paying
    # 
    # Your application should implement behavior corresponding to each of these events
    # in this concern file
    # 
    def respond_to_webhook
      case @notification.kind
      when "resources.suspended"
        logger.info "resource suspended"
      when "resources.reactivated"
        logger.info "resource reactivated"
      end
    end
end