require 'rails/generators'
require 'date'

module DoAddonConnector
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../..", __FILE__)

      # def copy_migrations
      #   bin/rails do_addon_connector:install:migrations
      #   rake "db:migrate"
      # end

      def copy_initializers
        directory "lib/generators/do_addon_connector/initializers", "config/initializers"
      end

      def copy_model_concern
        directory "lib/generators/do_addon_connector/models/concerns", "app/models/concerns"
      end

      def copy_controller_concern
        directory "lib/generators/do_addon_connector/controllers/concerns", "app/controllers/concerns"
      end

      def display_readme
        readme 'README'
      end
    end
  end
end
