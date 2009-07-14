class Member < ActiveRecord::Base
  belongs_to :student #, :foreign_key => "student_no"
  belongs_to :organization
end
