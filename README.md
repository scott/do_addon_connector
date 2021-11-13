# DO Addon Connector

Description of what it does.  Sets up your site to connect with DO via resource provisioning, plan updates, and SSO.

## Requirements

Currently requires that you provide authentication with `Devise`, and a `User` model.  Rails 6.1

## Installation
Add to your gem file.

``` bash
gem 'do_addon_connector', git: 'https://github.com/scott/do_addon_connector'
bundle 
bin/rails do_addon_connector:install:migrations
rails db:migrate
```

## Configuration

You can create an initializer at `do_addon_connector.rb` as follows:

``` ruby
# config/initializers/do_addon_connector.rb

DoAddonConnector.setup do |config|
  # 
  # Service Name
  # ======================
  # This is the name of the parent service
  config.service_name = "YourApp"

  # App Slug
  # ======================
  # This is the slug used by your app
  config.slug = "your_slug"

  # Source
  # ======================
  # This represents the source of the user
  config.source = 'do'

  # SSO Redirect
  # ======================
  # This determines where the user should be taken after a successful SSO
  config.redirect_to = 'https://yoursite.com'
end
```

If you collect additonal user information at sign up, this will be provided during resource provisioning in the `metadata` section.  You can then use this information to further set up the user or prepare their account by adding a `concern` that extends the `Customer` object:

``` ruby
# app/models/concerns/customer_extensions.rb
# Define additional setup actions here that you will need after 
# the resource has been added

module CustomerExtensions
  extend ActiveSupport::Concern

  included do
    # associations and other class level things go here
    after_create :update_user
  end

  # instance methods and code go here
  def update_user
    logger.info("Update User Attributes")
    u = User.find(user_id)
    u.first_name = metadata['first_name']
    u.last_name = metadata['last_name']
    u.plan = plan
    u.save!
  end
end
```
Then to make sure this gets included, add the intializer:
``` ruby
# config/initializers/customer_extensions.rb

Rails.application.config.to_prepare do
  DoAddonConnector::Customer.include CustomerExtensions
end
```


This gem expects `ENV` vars to authenticate and sign requests.  When you build your integration, you will get the following, and should set these vars on your server:

`DO_PASSWORD`
`DO_SSOSALT`
`DO_CLIENTSECRET`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
