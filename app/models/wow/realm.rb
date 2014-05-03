module Wow
  class Realm < ActiveRecord::Base
    self.table_name = 'wow_realms'

    has_many :auctions

    validates :slug, :name, presence: true
  end
end
