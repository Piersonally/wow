require 'net/http'

module Wow
  module BattleNet

    class ApiClient

      def initialize(options = {})
        @region = options[:region] || 'us'
        @locale = options[:locale] || 'en_US'
      end

      def auctions_datafile_location_for_realm(realm)
        uri = request_uri "auction/data/#{realm}"
        response = Net::HTTP.get_response uri
        unless response.is_a? Net::HTTPOK
          raise "Unexpected response #{response.inspect} to GET #{uri}"
        end
        JSON.parse response.body
      end

      private

      def request_uri(sub_path, params={})
        URI::HTTP.build host: api_host,
                        path: base_path + sub_path,
                        query: "locale=#{@locale}"
      end

      def api_host
        "#{@region}.battle.net"
      end

      def base_path
        '/api/wow/'
      end
    end
  end
end
