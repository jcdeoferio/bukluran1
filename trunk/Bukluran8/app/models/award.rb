class Award < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :name, :message => "of award can't be blank"
end
