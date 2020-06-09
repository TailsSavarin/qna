FactoryBot.define do
  # Sequence of some uniq values for creating an body
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    question
    body

    trait :invalid do
      body { nil }
    end
  end
end
