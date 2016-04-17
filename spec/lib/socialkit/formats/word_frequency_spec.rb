require 'socialkit'
require 'ostruct'
require 'json'

describe "Formats::WordFrequency" do
  let(:data) do
    {
        "takes"=>4,
        "drag"=>4,
        "ive"=>4,
        "hung"=>4,
        "phone"=>4,
        "saying"=>4,

    }
  end

  let(:formater) { Socialkit::Formats::WordFrequency.new(data) }

  context "JSON" do
    it "takes ruby hash and makes it tag cloud friendly " do
      expect(formater.json).to be_a String
    end

    context "Attrs" do
      let(:attrs) { JSON.parse(formater.json) }

      it "has data as wrapper" do
        expect(attrs["data"]).to be_a Array
      end

      it "has word and count as payload" do
        expect(attrs["data"].first).to be_a Hash
      end

      it "has labeled attributes" do
        expect(attrs["data"].first.keys).to eql ["name", "count"]
      end
    end
  end
end