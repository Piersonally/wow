module Wow
  class Realm < ActiveRecord::Base
    self.table_name = 'wow_realms'

    validates :slug, :name, presence: true
  end
end
