# frozen_string_literal: true

FactoryBot.define do
  factory :personal do
    currency_id {'USD'}
    capital {100_000}
    description {'user test epersonal wallet'}
  end
end
