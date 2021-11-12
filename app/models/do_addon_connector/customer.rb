module DoAddonConnector
  class Customer < ApplicationRecord
    validates :user_id, uniqueness: true
    validates :key, uniqueness: true

    belongs_to :user
  end
end
