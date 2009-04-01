class Membership < ActiveRecord::Base
  belongs_to :student
  belongs_to :organization
  
end
