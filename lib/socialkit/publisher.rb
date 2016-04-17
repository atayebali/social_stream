require 'socialkit'
require 'pusher'
module Socialkit
  class Publisher

    def initialize manager
      @manager = manager
      @data    = {}
      @channel = manager.config_reader.brand
      @limit   = manager.config_reader.top_limit
      @event   = ''
    end

    def examine
      begin
        fetch
      rescue => exception
        error = <<-MSG
        Failed to fetch data from data store
        #{exception.message}
        MSG
        puts error
      end
    end

    def connect
      set_credentials
    end

    def trigger
      @data = {}
      fetch
      push_content
    end


    private
    def fetch
      @manager.store.map do |cursor|
        @data[cursor.first] = cursor.last
      end
    end

    def set_credentials
      config = @manager.config_reader.config["pusher"]
      if !config.nil? && !config.empty?
        Pusher.app_id = config['app_id']
        Pusher.key    = config['key']
        Pusher.secret = config['secret']
      end
    end

    def push_content
      formater = Socialkit::Formats::WordFrequency.new(@data)
      Pusher.trigger("starbucks",
                      "cloud_event",
                      formater.json)
    end
  end
end