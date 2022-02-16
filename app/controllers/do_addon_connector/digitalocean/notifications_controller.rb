
# // POST /digitalocean/notifications
# // Content-Type: application/json
# // Authorization: Basic YWNtZToxMjM0

# {
# 	"type": "resources.suspended", 
#   "created_at": 1620915831,
# 	"payload": {
# 		"resources_uuids": []
# 	}
# }

class DoAddonConnector::Digitalocean::NotificationsController < DoAddonConnector::Digitalocean::BaseController
  
  def create
    @notification = DoAddonConnector::Notification.new(
      kind: params[:type],
      payload: params[:payload]
    )

    @notification.save

    render status: '200', json: :ok
  end

end
