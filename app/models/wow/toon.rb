module Wow
  class Toon < ActiveRecord::Base
    self.table_name = 'wow_toons'

    belongs_to :user
    belongs_to :realm

    validates :realm_id, :name, presence: true

    def full_name
      "#{realm.name}-#{name}"
    end
  end
end
