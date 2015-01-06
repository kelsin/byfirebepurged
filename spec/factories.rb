FactoryGirl.define do
  factory :session do
    key { SecureRandom.uuid }
    account
    access_token 'access_token'
  end

  factory :account do
    sequence(:battletag, 1000) { |n| "Test##{n}" }
    sequence :account_id, 10000
    key { SecureRandom.uuid }

    factory :admin do
      admin true
    end
  end

  factory :character do
    account
    guild

    sequence(:name) { |n| "Character-#{n}" }
    realm "Realm"
    image_url "https://image_url"
    level 100
    race_id 1
    class_id 2
    gender_id 0

    factory :low_level_character do
      level 90
    end

    factory :heroic_character do
      item_level 630
    end

    factory :raiding_character do
      item_level 645
    end
  end

  factory :guild do
    name "Guild Name"
    realm "Realm"

    factory :other_guild do
      name "Guild Name 2"
    end
  end

  factory :raid do
    sequence(:name) { |n| "Raid #{n}" }
    date { 1.hour.from_now }
    note 'Raid Note'
    finalized false
    account

    factory :required_level_raid do
      requiredLevel 100
    end

    factory :required_ilevel_raid do
      requiredItemLevel 640
    end
  end
end
