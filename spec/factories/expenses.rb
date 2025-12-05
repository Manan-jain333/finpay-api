FactoryBot.define do
  factory :expense do
    title { "Test Expense" }
    amount { 2000 }
    date { Date.today }
    association :employee
    association :category
    status { "pending" } # AASM initial state

    trait :approved do
      status { "approved" }
    end

    trait :rejected do
      status { "rejected" }
    end

    trait :reimbursed do
      status { "reimbursed" }
    end

    trait :archived do
      status { "archived" }
    end
  end
end
