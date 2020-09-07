class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.integer :wallet_id
      t.integer :from_id
      t.string :message
      t.boolean :is_confirmed, default: false
      t.boolean :is_declined

      t.timestamps
    end
  end
end
