module Wow
  module UserExtensions
    extend ActiveSupport::Concern

    included do
      has_many :toons, class_name: 'Wow::Toon'
    end
  end
end
