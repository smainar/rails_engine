FactoryBot.define do
  factory :item do
    association :merchant, factory: :merchant
    sequence(:name) { |n| "Item Name #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:unit_price) { |n| n + 100 }
  end
end
