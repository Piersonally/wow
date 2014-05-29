require 'net/http'

module Wow
  module BattleNet

    class ApiClient
      include HTTParty

      def initialize(options = {})
        @region = options[:region] || 'us'
        @locale = options[:locale] || 'en_US'
        self.class.base_uri api_host + base_path
      end

      def auctions_datafile_location_for_realm(realm)
        uri = "/auction/data/#{realm}"
        response = self.class.get uri, query: { locale: @locale }
        unless response.ok?
          raise "Unexpected response #{response.inspect} to GET #{uri}"
        end
        response.parsed_response
      end

      def item(blizz_item_id)
        uri = "/item/#{blizz_item_id}"
        response = self.class.get uri, query: { locale: @locale }
        unless response.ok?
          raise "Unexpected response #{response.inspect} to GET #{uri}"
        end
        response.parsed_response
      end

      private

      def api_host
        "#{@region}.battle.net"
      end

      def base_path
        '/api/wow/'
      end
    end
  end
end
