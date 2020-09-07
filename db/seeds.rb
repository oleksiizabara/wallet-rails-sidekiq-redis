# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
[
  { id: 'JPY' },
  { id: 'USD' },
  { id: 'EUR' }
].each do |currency|
  Currency.find_or_create_by(currency)
end

[
  { from: 1, to: 100, price: 1 },
  { from: 101, to: 1000, price: 5 },
  { from: 1001, to: 100_000, price: 10 },
  { from: 100_001, to: nil, price: 100 }
].each do |currency|
  TransactionPlan.find_or_create_by(currency)
end
