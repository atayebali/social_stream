require 'socialkit'

describe 'Manager' do

  let(:manager) {Socialkit::Manager.new}
  let(:config_reader) { Socialkit::ConfigReader.new }
  before do
    allow(config_reader).to receive(:yaml).and_return({})
    allow(config_reader).to receive(:open_file).and_return({})
    config_reader.read

    allow(Socialkit::Services::TwitterStream).to receive(:new).and_return true

    allow_any_instance_of(Socialkit::ConfigReader).to(
      receive(:read).and_return(config_reader))
    allow_any_instance_of(Socialkit::Services::TwitterStream).to(
        receive(:build_client).and_return("client"))
  end

  context "Initialization" do
    before do
      allow(Socialkit::Persistor).to(
          receive(:new).and_return(true))
      allow(Socialkit::Services::TwitterStream).to(
          receive(:new).and_return(true))
      allow(Socialkit::Publisher).to(
          receive(:new).and_return(true))
      allow(Socialkit::Filter).to(
          receive(:new).and_return(true))
    end

    context "Initialize Config" do
      it " is set" do
        expect(manager.config_reader).to be_a Socialkit::ConfigReader
      end
    end

    context "Initializes Persistor" do
      it "is set" do
        expect(manager.persistor).to eql true
      end
    end

    context "Initializes Service" do
      it " is set" do
        expect(manager.service).to eql true
      end
    end

    context "Initializes Filter" do
      it "is set" do
        expect(manager.filter).to eql true
      end
    end

    context "Initializes Publisher" do
      it " is set" do
        expect(manager.publisher).to eql true
      end
    end
  end

  context "Exit" do
    it "closes the env upon exit" do
      expect(manager.persistor).to receive(:close)
      manager.close_connect
    end
  end


  context "Process" do
    let(:tweet) {"(Fav if you agree to http://tco.asdfasfd.com this) 💜)" }

    context "Filter" do
      before do
        expect(manager.filter).to receive(:run)
      end

      it "sends raw tweets to filter" do
        manager.process(tweet)
      end
    end

    context "Persistor" do
      before do
        allow(manager.publisher).to receive(:trigger).and_return("pushed")
        expect(manager.persistor).to receive(:add)
      end

      it "adds keywords to store" do
        manager.process(tweet)
      end
    end

    context "Publisher" do
      before do
        allow(manager.persistor).to receive(:add).and_return("added")
      end

      context "With publish flag" do
        before do
          allow(manager).to receive(:publish?).and_return(true)
          expect(manager.publisher).to receive(:trigger)
        end

        it "publishes json" do
          expect(manager).to receive(:publish?)
          manager.process(tweet)
        end
      end

      context "Without publish flag" do
        before do
          allow(manager).to receive(:publish?).and_return(false)
          expect(manager.publisher).to_not receive(:trigger)
        end

        it "publishes json" do
          expect(manager).to receive(:publish?)
          manager.process(tweet)
        end
      end
    end
  end

  context "Post Process" do
    before do
      allow(manager).to receive(:clean_and_store).and_return(true)
    end

    after do
      manager.process("blah")
    end

    it "checks for 1 hour duration" do
      allow(manager).to receive(:hour_expired?).and_return(true)
      expect(manager.persistor).to receive(:clear)
    end

    it "duration is one hour it clears out db" do
      allow(manager).to receive(:hour_expired?).and_return(false)
      expect(manager.persistor).to_not receive(:clear)
    end
  end
end