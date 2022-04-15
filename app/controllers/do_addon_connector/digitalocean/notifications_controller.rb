class DoAddonConnector::Digitalocean::NotificationsController < DoAddonConnector::Digitalocean::BaseController
  
  def create
    @notification = DoAddonConnector::Notification.new(
      kind: params[:type],
      payload: params[:payload]
    )

    if @notification.save
      if DoAddonConnector.debug == true
        logger.info("********* Notification Received ********")
        logger.info("#{params}")
      end
      render status: '200', json: :ok
    else
      if DoAddonConnector.debug == true
        logger.info("********* Notification Error ********")
        logger.info("#{params}")
      end
      render status: '500'
    end
  end

end
