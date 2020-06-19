FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    url { 'https://www.google.com' }
    name { 'Google' }
  end
end
