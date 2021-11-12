require 'rails/generators'
require 'date'

module DoAddonConnector
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('..', __FILE__)

      def copy_migrations
        # rake "railties:install:migrations"
        # rake "db:migrate"
      end

      def copy_initializer
        copy_file "config/initializers/do_addon_connector.rb", "config/initializers/do_addon_connector.rb"
      end

      def display_readme
        readme 'README'
      end
    end
  end
end
