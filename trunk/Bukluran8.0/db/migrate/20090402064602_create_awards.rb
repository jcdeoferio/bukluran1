class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.integer :organization_id
      t.string :name
      t.string :file_path
      t.string :classification
      t.string :description
      t.string :award_giving_body

      t.timestamps
    end
  end

  def self.down
    drop_table :awards
  end
end
