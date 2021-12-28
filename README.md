# DO Addon Connector

Sets up your site to connect with DO via resource provisioning, plan updates, and SSO.

## Requirements

Currently this gem supports Rails 6.1.  If you use Devise to authenticate `Users`, this should work mostly out of the box.  Each customer of your addon will be mapped to a single `User` in your app. With some customization (see below) you could easily adapt this to work with some other approach, like `Account` or `Tenant` mapping. 

## Installation

Add to your `Gemfile`.

``` bash
gem 'do_addon_connector', git: 'https://github.com/scott/do_addon_connector'
bundle install
```

Next install and migrate the database, then run the installation script:

```
bin/rails do_addon_connector:install:migrations
rails db:migrate
bin/rails g do_addon_connector:install
```

Finally, mount the connector in `routes.rb`
```
  mount DoAddonConnector::Engine => '/connectors'
```

The install script will add an initializer and some `Concerns` which give you complete flexibility over how your application reacts to a provisioning or SSO request. 

## Configuration

The initializer `do_addon_connector.rb` adds values as follows:

``` ruby
# config/initializers/do_addon_connector.rb

DoAddonConnector.setup do |config|
  # 
  # Service Name
  # ======================
  # This is the name of the parent service
  config.service_name = "Application"

  # App Slug
  # ======================
  # This is the slug used by your app
  config.slug = "acme"

  # Password
  # ======================
  # This is the password assigned to your resource
  config.password = "password" 

  # Salt
  # ======================
  # This is the salt assigned to your resource
  config.salt = "sso_salt"
  
  # Secret
  # ======================
  # This is the client secret assigned to your resource
  config.secret = "do_secret"

  # Token Expiration
  # ======================
  # This is how long in seconds before the token is expired
  config.token_expires_in = 120

  # Source
  # ======================
  # This represents the source of the user
  config.source = 'digitalocean'

  # SSO Redirect
  # ======================
  # This determines where the user should be taken after a successful SSO
  config.redirect_to = 'https://scrubl.com/dashboard'
end

```
## Custom behavior with Concerns

The installation script adds several `Concerns` were to your app.  These are used to define app behavior in response to the different actions provided by the provisioning service:

**Resource Creation** - when the service sends a resource creation request, your app should add an account and/or create a login for the user who has provisioned the app.  You can configure how the account/user gets created using: https://github.com/scott/do_addon_connector/blob/master/lib/generators/do_addon_connector/controllers/concerns/resources_controller_extension.rb

**Other Resource actions**

As well as add some additional context from metadata and the initial plan the user is subscribed to here: https://github.com/scott/do_addon_connector/blob/master/lib/generators/do_addon_connector/models/concerns/customer_extensions.rb

**Plan upgrade/downgrade** - The above file also includes an action for upgrading and downgrading plans in response to a request from the provisioning service.

**Resource destruction** - When DO sends a resource deletion request, your app will need to handle that.  You can specifyc what else will happen in this `Concern`.

**SSO Login request** - When a DO user sends a SSO request, you will need to log them into your app. How you authenticate a user is up to your app, but you can use the following to respond to the SSO login request: https://github.com/scott/do_addon_connector/blob/master/lib/generators/do_addon_connector/controllers/concerns/sso_login_extension.rb



## Environment

This gem expects `ENV` vars to authenticate and sign requests.  When you build your integration, you will get the following, and should set these vars on your server:

`DO_PASSWORD`
`DO_SSOSALT`
`DO_CLIENTSECRET`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
