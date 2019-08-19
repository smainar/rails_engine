# Rales Engine - README

## About

Rales Engine is a JSON API which retrieves data from the following database tables: merchants, items, customers, invoices, invoice_items, and transactions. Only ReSTful controller actions were allowed (`#index` & `#show`). 

## Setup on your machine

* Ruby version 2.4.1

* Configuration
`$bundle`

* Database creation
`$bundle exec rake db:drop`
`$bundle exec rake db:create`
`$bundle exec rake db:migrate`

* Database initialization
`$bundle exec rake csv_import`

* How to run the test suite
`$bundle exec rspec`
