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

  def self.ranked_by_most_items_sold(limit)
      select("merchants.*, SUM(invoice_items.quantity) AS count_of_items_sold")
      .joins(invoices: [:invoice_items, :transactions])
      .where(transactions: {result: "success"})
      .group(:id)
      .order("count_of_items_sold DESC")
      .limit(limit)
  end

  def total_revenue_by_merchant
    invoices.joins(:invoice_items, :transactions)
    .where(transactions: {result: "success"})
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
