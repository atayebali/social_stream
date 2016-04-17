require 'socialkit'
require 'ostruct'

describe "Service::TwitterStream" do
  let(:config) {OpenStruct.new :config => {"twitter" =>
                                              {"key" => "key",
                                               "query" => ['batman']}} }


  let(:manager) { OpenStruct.new :config_reader => config}
  let(:twitter) { Socialkit::Services::TwitterStream.new manager }
  let(:client) {double('client', :filter => "filtering")}

  before do
    allow(twitter).to receive(:build_client).and_return client
  end

  context "Initializes" do
    it "twitter" do
      expect(twitter).to be_a(Socialkit::Services::TwitterStream)
    end

    it "sets client" do
      twitter.attach
      expect(twitter.client).to eql client
    end
  end

  context  "Attach Service" do
    it "begins attachment" do
      expect(client).to receive(:filter).with(any_args)
      twitter.attach
    end
  end
end