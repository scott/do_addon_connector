# == Schema Information
#
# Table name: tokens
#
#  id         :uuid             not null, primary key
#  expires_at :datetime
#  kind       :string
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id    :integer
#
require "uri"
require "json"
require "net/http"
module DoAddonConnector
  class Token < ApplicationRecord
    def self.fetch(owner_id, token_id)
      token = DoAddonConnector::Token.where(owner_id: owner_id, id: token_id).last
      
      payload = {
        grant_type: token.kind,
        code: token.token,
        client_secret: DoAddonConnector.secret
      }.to_json

      if DoAddonConnector.debug == true
        logger.info("Fetching access_token and refresh_token")
        logger.info("POST #{payload.to_json}")
      end
      
      resp = HTTP.post("https://api.digitalocean.com/v2/add-ons/oauth/token", body: payload)
      req = JSON.parse(resp)

      logger.info("Token Service Response: \n#{resp}") if DoAddonConnector.debug == true

      DoAddonConnector::Token.create!(
        owner_id: owner_id,
        kind: "access_token",
        token: req['access_token'],
        expires_at: Time.now + req['expires_in'].to_i.seconds
      )

      DoAddonConnector::Token.create!(
        owner_id: owner_id,
        kind: "refresh_token",
        token: req['refresh_token'],
        expires_at: Time.now + req['expires_in'].to_i.seconds
      )
    end
    
    def self.refresh(owner_id)
      customer = DoAddonConnector::Customer.find_by(owner_id: owner_id)

      payload = {
        grant_type: "refresh_token",
        code: customer.refresh_token.token,
        client_secret: DoAddonConnector.secret
      }.to_json

      if DoAddonConnector.debug == true
        logger.info("Refreshing access_token")
        logger.info("POST #{payload}")
      end
      
      resp = HTTP.post("https://api.digitalocean.com/v2/add-ons/oauth/token", body: payload)
      req = JSON.parse(resp)

      logger.info("Token Service Response: \n#{resp}") if DoAddonConnector.debug == true

      DoAddonConnector::Token.create!(
        owner_id: owner_id,
        kind: "refresh_token",
        token: req['refresh_token'],
        expires_at: Time.now + req['expires_in'].to_i.seconds
      )

    end
  end
end
