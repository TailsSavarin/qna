FactoryBot.define do
  factory :answer do
    question
    body { 'AnswerBody' }

    trait :invalid do
      body { nil }
    end
  end
end
