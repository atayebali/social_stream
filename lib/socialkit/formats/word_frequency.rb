require 'socialkit'
require 'json'

module Socialkit
  module Formats
    class WordFrequency
      def initialize data
        @data = data
      end

      def json
        _json = @data.map do |word_hash|
          {
              "name" => word_hash.first,
              "count" => word_hash.last
          }
        end
        JSON.generate({"data" => _json})
      end
    end
  end
end