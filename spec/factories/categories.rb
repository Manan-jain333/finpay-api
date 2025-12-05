FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description { "Sample category description" }

    trait :travel do
      name { "Travel" }
      description { "Travel related expenses" }
    end

    trait :food do
      name { "Food" }
      description { "Meals and snacks" }
    end

    trait :office do
      name { "Office Supplies" }
      description { "Stationery and office-related items" }
    end
  end
end
