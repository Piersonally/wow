module Wow
  module ApplicationHelper

    def wow_price(price)
      copper = price % 100
      silver = price / 100 % 100
      gold = price / 10000
      content = content_tag(:span, copper.to_s, class: 'moneycopper')
      content = content_tag(:span, silver.to_s, class: 'moneysilver') + content if silver > 0
      content = content_tag(:span, gold.to_s, class: 'moneygold') + content if gold > 0
      content
    end

    def auctions_index_tabs_data
      [
        {
          name: "In Progress",
          href: in_progress_wow_auctions_path
        },
        {
          name: "Sold",
          href: sold_wow_auctions_path
        },
        {
          name: "Expired",
          href: expired_wow_auctions_path
        },
        {
          name: "All",
          href: wow_auctions_path
        }
      ]
    end
  end
end
