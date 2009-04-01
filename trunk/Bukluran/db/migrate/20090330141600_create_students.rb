class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.integer :student_no
      t.string :name
      t.string :degree_program
      t.string :gender
      t.boolean :enrolled
      t.string :webmail

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
