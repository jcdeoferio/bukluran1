class Student < ActiveRecord::Base
  has_many :memberships
  
  #set_primary_key "student_id"
  
  #
  validates_uniqueness_of :student_no
end
