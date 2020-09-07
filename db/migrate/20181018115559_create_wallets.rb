class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.string :type
      t.string :currency_id, default: 'USD'
      t.integer :capital, default: 0
      t.integer :admin_id
      t.boolean :is_private, default: true
      t.string :description
      t.string :encrypted_pin
      t.string :identity

      t.timestamps
    end
  end
end
