class CreateTransactionPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_plans do |t|
      t.integer :from
      t.integer :to
      t.integer :price

      t.timestamps
    end
  end
end
