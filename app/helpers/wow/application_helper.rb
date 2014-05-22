module Wow
  module ApplicationHelper

    def wow_price(price)
      copper = price % 100
      silver = price / 100 % 100
      gold = price / 10000
      "#{gold}g #{silver}s #{copper}c"
    end

    def auctions_index_tabs_data
      [
        {
          name: "In Progress",
          href: in_progress_wow_auctions_path
        },
        {
          name: "Completed",
          href: completed_wow_auctions_path
        },
        {
          name: "All",
          href: wow_auctions_path
        }
      ]
    end
  end
end
