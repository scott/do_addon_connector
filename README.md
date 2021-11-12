# DO Addon Connector

Description of what it does.  Sets up your site to connect with DO via resource provisioning, plan updates, and SSO.

## Requirements

Currently requires that you provide authentication with `Devise`, and a `User` model.  Rails 6.1

## Installation
Add to your gem file.

```
gem 'do_addon_connector'
bundle 
bin/rails do_addon_connector:install:migrations
rail db:migrate
```

## Configuration

You can create an initializer at `do_addons_connector.rb` as follows:

```
DoAddonConnector.setup do |config|
  # 
  # Service Name
  # ======================
  # This is the name of the parent service
  config.service_name = "YourApp"

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

This gem expects `ENV` vars to authenticate and sign requests.  When you build your integration, you will get the following, and should set these vars on your server:

`DO_SLUG`
`DO_PASSWORD`
`DO_SSOSALT`
`DO_CLIENTSECRET`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
