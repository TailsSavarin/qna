FactoryBot.define do
  factory :comment do
    user
    body

    trait :invalid do
      body { nil }
    end
  end
end
