FactoryBot.define do
  factory :transaction do
    association :invoice, factory: :invoice
    sequence(:credit_card_number) { |n| (n + 4000000000000000).to_s }
    credit_card_expiration_date { "2019-08-13" }
    result { "success" }
  end
end
