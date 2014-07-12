module Wow
  module BootstrapNavHelper

    def nav(nav_data, options={})
      ul_css_classes = CssClassList.new "nav", options[:class]
      content_tag(:ul, class: ul_css_classes) do
        enabled_items = enabled_nav_items nav_data
        enabled_items.map do |item_data|
          nav_item item_data
        end.join.html_safe
      end
    end

    def enabled_nav_items(items)
      items.reject do |item|
        (item.has_key?(:if) && item[:if] == false) ||
        (item.has_key?(:unless) && item[:unless] == true)
      end
    end

    def nav_item(item_data)
      li_classes = CssClassList.new
      li_classes << "active" if item_is_active?(item_data)
      li_classes << "dropdown" if item_data[:submenu]
      content_tag(:li, class: li_classes) do
        nav_item_content item_data
      end
    end

    def nav_item_content(item_data)
      if item_data[:content]
        item_data[:content].html_safe
      else
        link_to item_data[:name], item_data[:href], item_data[:link_options]
      end
    end

    def item_is_active?(item_data)
      if item_data[:active]
        if item_data[:active].is_a?(Regexp)
          request.path =~ item_data[:active]
        elsif item_data[:active].is_a?(Proc)
          item_data[:active].call
        end
      else
        request.path == item_data[:href]
      end
    end
  end
end
