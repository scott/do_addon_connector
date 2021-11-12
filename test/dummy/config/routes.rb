Rails.application.routes.draw do
  mount DoAddonConnector::Engine => "/do_addon_connector"
end
