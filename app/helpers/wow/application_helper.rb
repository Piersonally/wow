module Wow
  module ApplicationHelper

    def wow_price(price)
      copper = price % 100
      silver = price / 100 % 100
      gold = price / 10000
      "#{gold}g #{silver}s #{copper}c"
    end
  end
end
