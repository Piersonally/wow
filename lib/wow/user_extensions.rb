module Wow
  module UserExtensions
    extend ActiveSupport::Concern

    included do
      has_many :toons, class_name: 'Wow::Toon'
      has_many :bolos, class_name: 'Wow::Bolo', foreign_key: 'watcher_id'
    end
  end
end
