FactoryBot.define do
  factory :receipt do
    file_url { "https://example.com/receipt.png" }
    association :expense
  end
end
