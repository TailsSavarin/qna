FactoryBot.define do
  # Sequence of some uniq values for creating an email
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
