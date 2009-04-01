class Account < ActiveRecord::Base
  #belongs_to :administrator
  #belongs_to :organization
  #belongs_to :osa
  
  validates_presence_of :username, :password
  validates_uniqueness_of :username
  validates_length_of :password, :minimum => 5, :too_short => "must be atleast 5 characters long."
end
