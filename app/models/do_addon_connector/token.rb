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
module DoAddonConnector
  class Token < ApplicationRecord

    def self.fetch(owner_id, token_id)
      token = DoAddonConnector::Token.where(owner_id: owner_id, id: token_id).last
      
      payload = {
        grant_type: token.kind,
        code: token.token,
        client_secret: DoAddonConnector.secret
      }.to_json

      logger.info("Fetching access_token and refresh_token")
      logger.info("POST #{payload.to_json}")

      resp = HTTP.post("https://api.digitalocean.com/v2/add-ons/oauth/token", body: payload)
      req = JSON.parse(resp)

      # {
      # 	"access_token": "ACCESS_TOKEN_UUID", // Used to access the DigitalOcean API scoped to a single resource. Normally expires every 8 hours, but may expire early in certain circumstances.
      # 	"refresh_token": "REFRESH_TOKEN_UUID", // Valid for the lifetime of the resource and can be exchanged for a new access_token as many times as needed using a valid OAuth client_secret
      # 	"expires_in": 28800, // The number of seconds the access_token is valid for. The refresh_token is used to acquire a new access_token.
      # 	"token_type": "Bearer" // The token type is used in the Authorization header of requests to the DigitalOcean API
      # }

      logger.info("Token Service Response: \n#{resp}")

      DoAddonConnector::Token.create!(
        owner_id: owner_id,
        kind: "access_token",
        token: req['access_token'],
        expires_at: Time.now + req['expires_in'].to_i
      )

      DoAddonConnector::Token.create!(
        owner_id: owner_id,
        kind: "refresh_token",
        token: req['refresh_token'],
        expires_at: Time.now + req['expires_in'].to_i
      )
    end
  end
end
