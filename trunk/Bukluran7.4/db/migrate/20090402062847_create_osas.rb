class CreateOsas < ActiveRecord::Migration
  def self.up
    create_table :osas do |t|
      t.integer :account_id
      t.string :coordinator
      t.boolean :isopen, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :osas
  end
end
