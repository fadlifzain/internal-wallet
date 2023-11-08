class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.string   :wallet_id
      t.monetize :balance, default: 0

      t.references :account
      t.timestamps
    end
  end
end
