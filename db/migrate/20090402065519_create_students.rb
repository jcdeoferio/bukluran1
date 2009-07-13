class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.integer :student_no
      t.integer :year_level
      t.string :name #full name
      t.string :nickname
      t.string :degree_program #BS BA MS MA PHD PGA
      t.string :course
      t.string :college
      t.string :gender
      t.boolean :enrolled
      t.string :webmail
      t.string :permanent_address
      t.string :present_address
      t.string :title
      t.string :guardian
      t.string :guardian_address
      t.integer :guardian_telno
      t.integer :contact_no

      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
