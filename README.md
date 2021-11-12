# DO Addon Connector

Description of what it does.  Sets up your site to connect with DO via resource provisioning, plan updates, and SSO.

## Requirements

Currently requires that you provide authentication with `Devise`, and a `User` model.  Rails 6.1

## Installation
Add to your gem file.

```
gem 'do_addon_connector'
bundle 
rails do_addon_connector:install:migrations
```

Create your addon listing at DO.



## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
