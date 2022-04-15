require "do_addon_connector/version"
require "do_addon_connector/engine"
require "http"

module DoAddonConnector
  mattr_accessor :source
  mattr_accessor :redirect_to
  mattr_accessor :service_name
  mattr_accessor :slug
  mattr_accessor :token_expires_in
  mattr_accessor :password
  mattr_accessor :salt
  mattr_accessor :secret
  mattr_accessor :debug


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
