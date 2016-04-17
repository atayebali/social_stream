require 'socialkit'

module Socialkit
  class Persistor

    attr_accessor :store

    def initialize manager
      @manager = manager
      @config  = manager.config_reader
      @name    = @config.brand
    end

    def close
      @env.close
    end

    def clear
      @env.transaction do
        @store.clear
      end
    end

    def drop!
      @store.drop
    end

    def connect
      @env   = build_environment
      @store = build_or_fetch_db
    end

    def add keywords
      keywords.each do |keyword|
        safe_add keyword
      end
    end

    private

    def build_environment
      LMDB.new Dir.pwd
    end

    def build_or_fetch_db
     if @env.nil?
       raise "Environment could not be initialized by LMDB"
     else
       @main = @env.database
       @env.database @name, :create => true
     end
    end

    def safe_add word
      word = word.strip
      @env.transaction do
        count = @store.get(word)
        if count.nil?
          @store[word] = '1'
        else
          @store[word] = (count.to_i + 1).to_s
        end
      end
    end
  end
end