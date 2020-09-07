# frozen_string_literal: true

class CreateWalletTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_transactions do |t|
      t.integer :transaction_type, default: 0
      t.integer :status, default: 0
      t.integer :transaction_plan_id
      t.integer :tax
      t.string :currency_id, default: 'USD'
      t.integer :transfered_money
      t.boolean :tax_paid_by_the_recipient, default: false
      t.integer :initiator_id
      t.integer :wallet_from_id
      t.integer :wallet_to_id
      t.string :error_message

      t.timestamps
    end
  end
end
