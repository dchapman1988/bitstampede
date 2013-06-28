require_relative '../../spec_helper'

describe Bitstampede::Net do
  let(:client){ double }
  subject { described_class.new(client) }

  before do
    client.stub(:secret).and_return(1)
    client.stub(:key).and_return(2)
  end

  it 'gets instantiated with a client' do
    expect(subject.client).to eq(client)
  end

  it 'defers to its client for secret' do
    expect(subject.secret).to eq(1)
  end

  it 'defers to its client for key' do
    expect(subject.key).to eq(2)
  end

  describe '#post' do
    describe 'balance' do
      let(:example_balance) do
        <<-JSON
          {
            "usd_balance": "12.34",
            "btc_balance": "23.45",
            "usd_reserved": "1.11",
            "btc_reserved": "2.22",
            "usd_available": "11.23",
            "btc_available": "21.23",
            "fee": "0.5"
          }
        JSON
      end

      before do
        FakeWeb.register_uri(:post, "https://www.bitstamp.net/api/balance/", body: example_balance)
      end

      it "queries the api appropriately for the balance" do
        expect(json_parse(subject.post('balance'))).to eq(json_parse(example_balance))
      end
    end
  end
end
