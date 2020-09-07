# frozen_string_literal: true

class TransactionPlan < ApplicationRecord
  has_many :wallet_transactions
end
