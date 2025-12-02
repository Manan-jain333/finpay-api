FactoryBot.define do
  factory :employee do
    name { "John Doe" }
    email { Faker::Internet.email }
    age { 25 }
  end
end
