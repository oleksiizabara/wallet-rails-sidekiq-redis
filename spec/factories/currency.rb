# frozen_string_literal: true

FactoryBot.define do
  factory :currency do
    id {'USD'}
  end

  trait :eur do
    id {'EUR'}
  end
end
