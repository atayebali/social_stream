require 'socialkit'
describe "Filter" do
  let(:filter) { Socialkit::Filter.new }
  context "Initialize Filter" do

    it "is valid" do
      expect(filter).to be_a(Socialkit::Filter)
    end

    it "has stopwords" do
      expect(Socialkit::STOPWORDS).to_not be_empty
    end
  end

  context "Perform filtration" do
    let(:tweet) {"(Fav if you agree to http://tco.asdfasfd.com this) 💜)" }
    it "runs sieve" do
      expect(filter).to receive(:seive)
      expect(filter).to receive(:prepare)
      filter.run tweet
    end

    context "Filtered results" do
      let(:clean_words){ filter.run(tweet) }

      it "does not have empty strings" do
        expect(clean_words).to_not include ""
      end

      it "does not have http links" do
        expect(clean_words.join).to_not include "http"
      end

      it "does not have punctuation" do
        expect(clean_words.join).to match /[a-z0-9]/
      end

      it "does not have one letter words" do
        clean_words.each do |w|
          expect(w.size).to be > 1
        end
      end
    end
  end

  context "Language detection" do
    context "English" do
      let(:en) { "hello this is a test" }
      let(:clean_words) { filter.run(en) }
      it "is english" do
        expect(clean_words).to include "hello"
      end
    end

    context "Spanish" do
      let(:es) { "mi gusta mucho bailar y comer " }
      let(:clean_words) { filter.run(es) }
      it "is english" do
        expect(clean_words).to_not include "comer"
      end
    end
  end
end