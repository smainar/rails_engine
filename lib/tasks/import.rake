require "csv"

namespace :import do
  desc "Import data from CSV files"
  task data: :environment do

    CSV.foreach("./data/customers.csv", headers: true, header_converters: :symbol) do |row|
      Customers.create(row.to_h)
    end

    CSV.foreach("./data/invoice.csv", headers: true, header_converters: :symbol) do |row|
      Invoice.create(row.to_h)
    end

    CSV.foreach("./data/invoice_items.csv", headers: true, header_converters: :symbol) do |row|
      InvoiceItem.create(row.to_h)
    end

    CSV.foreach("./data/items.csv", headers: true, header_converters: :symbol) do |row|
      Item.create(row.to_h)
    end

    CSV.foreach("./data/merchants.csv", headers: true, header_converters: :symbol) do |row|
      Merchant.create(row.to_h)
    end

    CSV.foreach("./data/transactions.csv", headers: true, header_converters: :symbol) do |row|
      Transaction.create(row.to_h)
    end
  end
end
