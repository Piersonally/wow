require "spec_helper"

describe Wow::ItemFetcher do
  let(:fetcher) { Wow::ItemFetcher.new item_id }
  let(:item_id) { 18803 } # "Finkle's Lava Dredger"
  let(:battlenet_response) {
    '{"id":18803,"disenchantingSkillRank":225,"description":"Property of Finkle Einhorn, Grandmaster Adventurer","name":"Finkle\'s Lava Dredger","icon":"inv_gizmo_02","stackable":1,"itemBind":1,"bonusStats":[{"stat":51,"amount":15},{"stat":5,"amount":24},{"stat":6,"amount":22},{"stat":7,"amount":25}],"itemSpells":[],"buyPrice":474384,"itemClass":2,"itemSubClass":5,"containerSlots":0,"weaponInfo":{"damage":{"min":159,"max":239,"exactMin":159.28119,"exactMax":239.0},"weaponSpeed":2.9,"dps":68.66917},"inventoryType":17,"equippable":true,"itemLevel":70,"maxCount":0,"maxDurability":120,"minFactionId":0,"minReputation":0,"quality":4,"sellPrice":94876,"requiredSkill":0,"requiredLevel":60,"requiredSkillRank":0,"itemSource":{"sourceId":179703,"sourceType":"GAME_OBJECT_DROP"},"baseArmor":0,"hasSockets":false,"isAuctionable":false,"armor":0,"displayInfoId":31265,"nameDescription":"","nameDescriptionColor":"000000","upgradable":false,"heroicTooltip":false}'
  }
  let!(:get_request_stub) {
    stub_request(:get, "http://us.battle.net/api/wow/item/#{item_id}?locale=en_US").
      to_return(:status => 200, :body => battlenet_response,
                :headers => { 'Content-Type' => 'application/json'} )
  }

  describe "#fetch" do
    subject { fetcher.fetch }

    it "looks up the item at battle.net" do
      subject
      expect(get_request_stub).to have_been_requested.once
    end

    it "creates a new item record" do
      expect { subject }.to change(Wow::Item, :count).by(1)
      item = Wow::Item.last
      expect(item.blizz_item_id).to eq 18803
      expect(item.name).to eq "Finkle's Lava Dredger"
      expect(item.data).to eq JSON.parse(battlenet_response)
    end

    it "returns the new item record" do
      item = subject
      expect(item).to be_a Wow::Item
      expect(item).to be_persisted
    end

    describe "given there are some auctions of this item" do
      let(:auction) { create :auction, blizz_item_id: '18803' }

      it "updates matching auctions with the new Item's id" do
        expect(auction.item_id).to be_nil
        subject
        expect(auction.reload.item_id).to eq Wow::Item.last.id
      end
    end
  end
end
