class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than: 0
  }

  validates :unit_price, presence: true, numericality: {
    only_integer: true,
    greater_than: 0
  }
end
