class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.integer :student_id
      t.integer :organization_id
      t.string :position
      t.integer :semester
      t.integer :year
      t.boolean :confirm
      t.string :confirmation_key
      t.boolean :sentcnfrm #flag for sent email

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
