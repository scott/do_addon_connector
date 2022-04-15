module DoAddonConnector
  class Customer < ApplicationRecord
    validates :owner_id, uniqueness: true
    validates :key, uniqueness: true

    def update_config(vars = {})

      # check if access token is expired, refresh if needed
      if Time.now > self.access_token.expires_at
        DoAddonConnector::Token.refresh(self.owner_id)
      end

      # send config vars
      
      payload = {
        "config": vars
      }.to_json
      resp = HTTP.auth("Bearer #{self.access_token.token}").patch("https://api.digitalocean.com/v2/add-ons/resources/#{self.key}/config", body: payload)
      req = JSON.parse(resp)
    end

    def access_token
      DoAddonConnector::Token.where(owner_id: self.owner_id, kind: 'access_token').order(created_at: :desc).last
    end

    def refresh_token
      DoAddonConnector::Token.where(owner_id: self.owner_id, kind: 'refresh_token').order(created_at: :desc).last
    end

  end
end
