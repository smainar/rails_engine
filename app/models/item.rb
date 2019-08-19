class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description

  validates :unit_price, presence: true, numericality: {
    only_integer: true,
    greater_than: 0
  }

  def self.ranked_by_most_revenue(limit)
    select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(invoices: :transactions)
    .where(transactions: {result: "success"})
    .group(:id)
    .order("revenue DESC")
    .limit(limit)
  end

  def self.ranked_by_most_sold(limit)
    select("items.*, SUM(invoice_items.quantity) AS total_items_sold")
    .joins(invoices: :transactions)
    .where(transactions: {result: "success"})
    .group(:id)
    .order("total_items_sold DESC")
    .limit(limit)
  end

  # def best_day(limit)
  #   invoices.select("invoices.created_at AS date, SUM(invoice_items.quantity) AS total_items_sold")
  #   .joins(:transactions)
  #   .where(transactions: {result: "success"})
  #   .group("date")
  #   .order("total_items_sold DESC, date DESC")
  #   .limit(limit)
  # end
end
