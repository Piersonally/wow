module Wow
  class Realm < ActiveRecord::Base
    validates :slug, :name, presence: true
  end
end
