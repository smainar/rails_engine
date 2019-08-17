require "csv"

namespace :import do
  desc "Import data from CSV files"
  task data: :environment do
    Merchant.destroy_all
    Item.destroy_all
    Customer.destroy_all
    Invoice.destroy_all
    InvoiceItem.destroy_all
    Transaction.destroy_all

    puts "Loading Customer CSV data"
    CSV.foreach("./data/customers.csv", headers: true, header_converters: :symbol) do |row|
      Customer.create(row.to_h)
    end

    puts "Loading Invoice CSV data"
    CSV.foreach("./data/invoices.csv", headers: true, header_converters: :symbol) do |row|
      Invoice.create(row.to_h)
    end

    puts "Loading InvoiceItems CSV data"
    CSV.foreach("./data/invoice_items.csv", headers: true, header_converters: :symbol) do |row|
      InvoiceItem.create(row.to_h)
    end

    puts "Loading Items CSV data"
    CSV.foreach("./data/items.csv", headers: true, header_converters: :symbol) do |row|
      Item.create(row.to_h)
    end

    puts "Loading Merchants CSV data"
    CSV.foreach("./data/merchants.csv", headers: true, header_converters: :symbol) do |row|
      Merchant.create(row.to_h)
    end

    puts "Loading Transactions CSV data"
    CSV.foreach("./data/transactions.csv", headers: true, header_converters: :symbol) do |row|
      Transaction.create(row.to_h)
    end
  end
end
