FactoryBot.define do
  # Sequence of some uniq values for creating an title
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do
    title
    user
    body { 'QuestionBody' }

    trait :invalid do
      title { nil }
    end
  end
end
