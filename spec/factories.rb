FactoryGirl.define do
  factory :session do
    key { SecureRandom.uuid }
    account
    access_token 'access_token'
  end

  factory :account do
    sequence(:battletag, 1000) { |n| "Test##{n}" }
    sequence :account_id, 10000

    factory :admin do
      admin true
    end
  end
end
