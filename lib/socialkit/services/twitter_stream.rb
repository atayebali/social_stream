require 'twitter'
require 'socialkit'


module Socialkit
  module Services
    class TwitterStream
      attr_reader :client

      def initialize manager
        @manager = manager
        @credentials = @manager.config_reader.config["twitter"]
        @queries = @credentials["query"].join(",")
      end

      def build_client
        Twitter::Streaming::Client.new do |config|
          config.consumer_key        = @credentials["consumer_key"]
          config.consumer_secret     = @credentials["consumer_secret"]
          config.access_token        = @credentials["access_token"]
          config.access_token_secret = @credentials["access_token_secret"]
        end
      end

      def attach
        @client = build_client
        begin
          @client.filter(track: @queries) do |object|
            if object.is_a?(Twitter::Tweet)
              if object.media.count > 0
                media = object.media
                text = object.text
                user_image = object.user.profile_image_uri(size = :bigger).to_s
                puts media.first.attrs[:media_url]



                conn = Faraday.new(:url => 'http://localhost:3000') do |faraday|
                  faraday.request  :url_encoded             # form-encode POST params
                  # faraday.response :logger                  # log requests to STDOUT
                  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
                end
                conn.post '/api/tweet_media', {:name =>  media.first.attrs[:media_url],
                                               :text => text,
                                               :user_pic => user_image
                                            }

              end
            end
          end
        rescue Interrupt
          puts "Cleaning db connect"
          puts "Session Terminated"
        ensure
          @manager.close_connect
        end
      end
    end
  end
end
