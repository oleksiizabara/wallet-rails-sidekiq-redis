class CreateFamilyWalletSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :family_wallet_settings do |t|
      t.integer :family_id
      t.json :user_settings, array: true, default: []

      t.timestamps
    end
  end
end
