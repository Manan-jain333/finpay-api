FactoryBot.define do
  factory :expense do
    title { "Test Expense" }
    amount { 2000 }
    date { Date.today }
    association :employee
    association :category
  end
end
