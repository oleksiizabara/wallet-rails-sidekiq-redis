class CreateJoinTableUserWalletTransaction < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :wallet_transactions do |t|
      # t.index [:user_id, :wallet_transaction_id]
      # t.index [:wallet_transaction_id, :user_id]
    end
  end
end
