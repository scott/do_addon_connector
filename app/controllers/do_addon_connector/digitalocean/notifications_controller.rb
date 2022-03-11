class DoAddonConnector::Digitalocean::NotificationsController < DoAddonConnector::Digitalocean::BaseController
  
  def create
    @notification = DoAddonConnector::Notification.new(
      kind: params[:type],
      payload: params[:payload]
    )

    if @notification.save
      render status: '200', json: :ok
    else
      render status: '500'
    end
  end

end
