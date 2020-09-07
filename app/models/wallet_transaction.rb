# frozen_string_literal: true

class WalletTransaction < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :wallets
  belongs_to :currency, optional: true
  belongs_to :transaction_plan, optional: true

  enum transaction_type: {
    replenish_your_wallet: 0,
    between_your_wallets: 1,
    to_another_wallet: 2
  }

  enum status: {
    new_transaction: 0,
    in_progress: 1,
    done: 2,
    failed: 3,
    decline: 4
  }
end
