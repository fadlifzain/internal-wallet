class CreateAuths < ActiveRecord::Migration[7.1]
  def change
    create_table :auths do |t|
      t.string :username
      t.string :password
      t.string :token
      t.datetime :expired_at

      t.timestamps
    end
  end
end
