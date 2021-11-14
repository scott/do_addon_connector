module DoAddonConnector
  class Customer < ApplicationRecord
    validates :owner_id, uniqueness: true
    validates :key, uniqueness: true
  end
end
