FactoryBot.define do
  factory :link do
    url { 'https://www.google.com' }
    name { 'Google' }

    trait :for_question do
      association :linkable, factory: :question
    end

    trait :for_answer do
      association :linkable, factory: :answer
    end
  end
end
