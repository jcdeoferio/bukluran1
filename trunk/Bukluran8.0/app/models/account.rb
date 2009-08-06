class Account < ActiveRecord::Base
  validates_presence_of :username, :password
  validates_uniqueness_of :username
  validates_length_of :password, :minimum => 5, :too_short => 'must be at least 5 characters long'
end
