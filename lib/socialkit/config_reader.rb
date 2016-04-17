require 'socialkit'
module Socialkit
  class ConfigReader
    attr_reader :brand
    attr_reader :query
    attr_reader :top_limit
    attr_reader :config

    def read
      @config = yaml open_file
      @brand = @config["brand"]
      @query = parse_query
      @top_limit = parse_top_limit
      self
    end

    %w(query top_limit).each do |parser_type|
      define_method "parse_#{parser_type}" do
        if @config["twitter"] && @config["twitter"][parser_type]
          @config["twitter"][parser_type]
        end
      end
    end

    def open_file
      File.open('config.yml')
    end

    def yaml file
      YAML::load file
    end
  end
end