FactoryBot.define do
  factory :invoice do
    status { "shipped" }
    association :customer, factory: :customer
    association :merchant, factory: :merchant
  end
end
