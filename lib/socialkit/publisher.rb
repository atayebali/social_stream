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
  end
end
