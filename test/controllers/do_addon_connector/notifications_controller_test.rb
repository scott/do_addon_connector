require "test_helper"

module DoAddonConnector
  class NotificationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get create" do
      get notifications_create_url
      assert_response :success
    end
  end
end
