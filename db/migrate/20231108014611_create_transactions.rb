class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string    :transaction_type
      t.string    :source_wallet
      t.string    :target_wallet
      t.string    :reference
      t.string    :transaction_note
      t.monetize  :amount
      t.timestamps
    end
  end
end
