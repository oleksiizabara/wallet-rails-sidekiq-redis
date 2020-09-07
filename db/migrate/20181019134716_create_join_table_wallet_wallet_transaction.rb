class CreateJoinTableWalletWalletTransaction < ActiveRecord::Migration[5.2]
  def change
    create_join_table :wallets, :wallet_transactions do |t|
      # t.index [:walet_id, :wallet_transaction_id]
      # t.index [:wallet_transaction_id, :walet_id]
    end
  end
end
