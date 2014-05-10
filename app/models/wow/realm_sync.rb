module Wow
  class RealmSync < ActiveRecord::Base
    self.table_name = 'wow_realm_syncs'

    belongs_to :realm
    has_many :auction_snapshots
  end
end
