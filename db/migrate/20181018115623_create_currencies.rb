class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table(:currencies, id: false) do |t|
      t.string :id, primary_key: true, null: false
      t.timestamps
    end
  end
end