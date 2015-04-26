FactoryGirl.define do
  factory :link, class: Hash do
    uid "testuid"
    pub0 "testpub"
    page "1"

    trait :missing_uid do
      uid ""
    end

    trait :missing_pub0 do
      pub0 ""
    end

    trait :invalid_page do
      page "invalid"
    end
  end
end
