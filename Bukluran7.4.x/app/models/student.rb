class Student < ActiveRecord::Base
  has_many :members
  #set_primary_key "student_id"
  #validates_uniqueness_of :student_no
end
