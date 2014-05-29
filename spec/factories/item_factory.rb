# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item, class: Wow::Item do
    blizz_item_id 18803
    name
    description "description"
    data '{"id":18803,"disenchantingSkillRank":225,"description":"Property of Finkle Einhorn, Grandmaster Adventurer","name":"Finkle\'s Lava Dredger","icon":"inv_gizmo_02","stackable":1,"itemBind":1,"bonusStats":[{"stat":51,"amount":15},{"stat":5,"amount":24},{"stat":6,"amount":22},{"stat":7,"amount":25}],"itemSpells":[],"buyPrice":474384,"itemClass":2,"itemSubClass":5,"containerSlots":0,"weaponInfo":{"damage":{"min":159,"max":239,"exactMin":159.28119,"exactMax":239.0},"weaponSpeed":2.9,"dps":68.66917},"inventoryType":17,"equippable":true,"itemLevel":70,"maxCount":0,"maxDurability":120,"minFactionId":0,"minReputation":0,"quality":4,"sellPrice":94876,"requiredSkill":0,"requiredLevel":60,"requiredSkillRank":0,"itemSource":{"sourceId":179703,"sourceType":"GAME_OBJECT_DROP"},"baseArmor":0,"hasSockets":false,"isAuctionable":false,"armor":0,"displayInfoId":31265,"nameDescription":"","nameDescriptionColor":"000000","upgradable":false,"heroicTooltip":false}'
  end
end
