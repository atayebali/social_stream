require 'cld'
module Socialkit
  class Filter

    def run raw_tweet
      @raw_tweet = raw_tweet
      prepare
      seive
    end

    private

    def prepare
      if is_english?
        text   = remove_binary
        @words = text.downcase.split(" ")
      else
        @words = []
      end
    end

    def is_english?
      CLD.detect_language(@raw_tweet)[:name] == "ENGLISH"
    end

    def seive
      remove_punctuation
      remove_stops
      apply_remove_rules
    end

    def remove_binary
      @raw_tweet.encode("utf-8", "binary",
                    :undef => :replace,
                    :replace => "")
    end

    def remove_stops
      @words = @words - Socialkit::STOPWORDS
    end

    def remove_punctuation
      @words = @words.map do |word|
        word.scan(/[a-z0-9]/)
      end.map(&:join).compact
    end

    def apply_remove_rules
      @words.delete_if { |word| invalid? word }
    end

    def invalid? word
      word.size <= 1         ||
      word.include?("http")
    end
  end
end