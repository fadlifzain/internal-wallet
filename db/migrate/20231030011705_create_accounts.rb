class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :username
      t.string :avatar_url
      t.string :type

      t.references :team, foreign_key: { to_table: :accounts }
      t.timestamps
    end
  end
end
