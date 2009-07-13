class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :organization_id
      t.string :name
      t.string :category
      t.string :description
      t.date :date
      t.string :venue
      t.string :head

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
