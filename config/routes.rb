DoAddonConnector::Engine.routes.draw do

    namespace :digitalocean do
        resources :resources
        resources :sso 
    end

end
