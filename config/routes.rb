DoAddonConnector::Engine.routes.draw do

    namespace :digitalocean do
        resources :resources
        resources :sso, only: :create

        get 'sso/sso_two' => 'sso#create', as: :sso_two

    end

end
