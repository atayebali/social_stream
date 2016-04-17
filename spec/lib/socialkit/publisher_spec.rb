require 'socialkit'

describe "Publisher" do
  let(:manager) { OpenStruct.new :config_reader => OpenStruct.new(:brand => "NO") }
  let(:publisher) { Socialkit::Publisher.new(manager) }
  let(:data) do
    {
        'a54partnersrock' => 1,
        'abchyosung' => 1,
        'acaba' => 1,
        'accenture' => 3,
        'aclaro' => 1,
        'actorlife' => 1,
    }
  end

  before do
    allow(publisher).to receive(:set_credentials).and_return(true)
  end

  context "Initialize Publisher" do
    context "Valid" do
      it "is a publisher" do
        expect(publisher).to be_a Socialkit::Publisher
      end

      it "#connects" do
        expect(publisher).to receive(:set_credentials)
        publisher.connect
      end
    end
  end

  context "High Level Api" do
    before do
      allow(publisher).to(
          receive(:fetch).with(any_args).and_return(data))
      allow(publisher).to(
          receive(:push_content).and_return(true))
    end

    it "#examine" do
      expect(publisher.examine).to eql data
    end

    context "Publish to real time platform" do
      it "#trigger" do
        expect(publisher).to receive(:push_content)
        publisher.trigger
      end
    end
  end
end