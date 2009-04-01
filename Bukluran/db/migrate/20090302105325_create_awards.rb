class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.integer :organization_id
      t.string :name
      t.string :classification
      t.text :description
      t.string :from

      t.timestamps
    end
  end

  def self.down
    drop_table :awards
  end
end
