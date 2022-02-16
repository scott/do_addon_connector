DoAddonConnector::Engine.routes.draw do

  get 'notifications/create'
    namespace :digitalocean do
        resources :resources
        resources :sso, only: :create
        resources :notifications, only: :create

        get 'sso/sso_two' => 'sso#create', as: :sso_two

    end

end
