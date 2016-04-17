require 'socialkit'
module Socialkit
  class Manager
    attr_reader :config_reader
    attr_reader :filter
    attr_reader :persistor
    attr_reader :service
    attr_reader :publisher
    attr_reader :publish

    def self.run opts={}
      @manager = new opts
      @manager.persistor.connect
      @manager.publisher.connect
      @manager.service.attach
    end

    def initialize opts={}
      opts[:publish] ? @publish = true : @publish = false
      @config_reader = Socialkit::ConfigReader.new.read
      @persistor     = Socialkit::Persistor.new self
      @filter        = Socialkit::Filter.new
      @service       = Socialkit::Services::TwitterStream.new self
      @publisher     = Socialkit::Publisher.new self
      @start_hour    = Time.now.hour
    end

    def process tweet
      clean_and_store tweet
      run_post_process
      publish_data
    end

    def clean_and_store tweet
      @keywords = @filter.run tweet
      @persistor.add @keywords if @keywords
    end

    def publish_data
      @publisher.trigger if @keywords && publish?
    end

    def run_post_process
      @persistor.clear if hour_expired?
    end

    def hour_expired?
      @start_hour != Time.now.hour
    end

    def store
      @persistor.store
    end
    
    def close_connect
      @persistor.close
    end

    private
    def publish?
      @publish
    end

  end
end