class Merchant < ApplicationRecord
  has_many :invoices
  has_many :items

  validates_presence_of :name

  def self.ranked_by_most_revenue(limit)
    select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: "success"})
    .group(:id)
    .order("revenue DESC")
    .limit(limit)
  end
end
