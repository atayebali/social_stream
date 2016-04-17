require 'socialkit'

describe 'Config Reader' do
  let(:config) { Socialkit::ConfigReader.new }
  context "Valid Config" do
    before do
      allow(config).to receive(:open_file).and_return("{}")
    end

    it "initializes" do
      expect{ config.read }.to_not raise_exception
    end
  end

  context "In Valid Config" do
    before do
      allow(config).to receive(:yaml).and_raise
    end
    it "initializes " do
      expect{config.read}.to raise_exception
    end
  end

  context "Attributes" do

    before do
      allow(config).to receive(:open_file).and_return true
      allow(config).to receive(:yaml).and_return(
        {"brand"=>"starbucks",
          "twitter"=>
              {"consumer_key"=>"KEY",
               "consumer_secret"=>"SECRET",
               "access_token"=>"TOKEN",
               "access_token_secret"=>"TOKEN_SECRET",
               "query"=>["starbucks"],
               "top_limit" => 3,
              },
          "pusher"=>
             {"app_id"=>12344,
              "key"=>"KEY",
              "secret"=>"SECRET"}}
      )
      config.read
    end

    it "#brand" do
      expect(config.brand).to eql "starbucks"
    end

    it "#query" do
      expect(config.query).to eql ["starbucks"]
    end

    it "#top_limit" do
      expect(config.top_limit).to eql 3
    end
  end
end