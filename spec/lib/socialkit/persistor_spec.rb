require 'socialkit'
require 'ostruct'


describe 'Persistor' do
  let(:config) {OpenStruct.new :brand => "NO"}
  let(:manager){OpenStruct.new :config_reader => config}

  # allow(manager).to

  context "Initialize Persistor" do
    let(:store) { OpenStruct.new(:clear => "clear", :drop! => "drop", :get => true) }
    let(:persistor) { Socialkit::Persistor.new(manager) }

    context "Valid" do
      before { allow(persistor).to receive(:build_environment).and_return("env") }
      before { allow(persistor).to receive(:build_or_fetch_db).and_return("store") }

      it "initializes a persistor" do
        expect{persistor}.to_not raise_exception
      end
      it "returns a persistor" do
        expect(persistor).to be_a(Socialkit::Persistor)
      end

      it "has set store correctly" do
        persistor.connect
        expect(persistor.store).to eql "store"
      end
    end

    context "Invalid" do
      before { allow(bad_persistor).to receive(:build_environment).and_raise }
      let(:bad_persistor) { Socialkit::Persistor.new(manager) }


      it "initializes a persistor" do
        expect{bad_persistor.connect}.to raise_exception
      end
    end
  end

  context "High Level Api" do
    let(:persistor) { Socialkit::Persistor.new(manager) }
    let(:env) { OpenStruct.new(:close => "close") }
    let(:store) { OpenStruct.new(:store => "store", :get => true) }

    before do
      allow(persistor).to receive(:build_environment).and_return(env)
      allow(persistor).to receive(:build_or_fetch_db).and_return(store)
      persistor.connect
    end

     it "closes environment" do
       expect(env).to receive(:close)
       persistor.close
     end

    it "clears store" do
      expect(env).to receive(:transaction)
      persistor.clear
    end

    it "drops store" do
      expect(store).to receive(:drop)
      persistor.drop!
    end

    context "Add a key" do
      let(:keywords) { %w(coffee tea cakes) }
      it "calls safe delete to store word" do
        expect(persistor).to receive(:safe_add).at_most(3).times
        persistor.add keywords
      end

    end

  end
end