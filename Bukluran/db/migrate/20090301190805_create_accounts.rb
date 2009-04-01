class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      #t.integer :user_id
      t.string :username
      t.string :password
      t.string :group

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
