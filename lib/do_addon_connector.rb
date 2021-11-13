require "do_addon_connector/version"
require "do_addon_connector/engine"

module DoAddonConnector
  mattr_accessor :source
  mattr_accessor :redirect_to
  mattr_accessor :service_name
  mattr_accessor :slug

  def self.redirect_to=(value)
    @@redirect_to = value
  end

  def self.source=(value)
    @@source = value
  end
  
  def self.setup
    yield self
  end


end
