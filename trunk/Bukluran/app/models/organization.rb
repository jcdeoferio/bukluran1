class Organization < ActiveRecord::Base
  belongs_to :account #, {:foreign_key => 'user_id'}
  has_many :events
  has_many :awards
  has_many :memberships
  
  validates_presence_of :name
end
