require 'spec_helper'

describe Wow::BattleNet::ApiClient do
  let(:client) { Wow::BattleNet::ApiClient.new }

  describe "#auctions_datafile_location_for_realm" do
    let(:subject) { client.auctions_datafile_location_for_realm(realm) }
    let(:json_result) { '{"some":"json"}' }
    let!(:get_request_stub) {
      stub_request(:get, "http://us.battle.net/api/wow/auction/data/baelgun?locale=en_US").
        to_return(:status => 200, :body => json_result,
                  :headers => { 'Content-Type' => 'application/json'} )
    }

    context "given a valid realm" do
      let(:realm) { 'baelgun' }

      it "attempts to contact the correct battlenet URI" do
        subject
        expect(get_request_stub).to have_been_requested.once
      end

      it "should return the parsed result" do
        expect(subject).to eq({"some" => "json"})
      end
    end

    # context "given an invalid realm" do
    #   let(:realm) { 'realm-that-does-not-exist' }
    #
    #   it "should raise an error" do
    #     expect { subject }.to raise_error
    #   end
    # end
  end
end
