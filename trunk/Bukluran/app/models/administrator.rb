class Administrator < ActiveRecord::Base
  belongs_to :account #, {:foreign_key => 'user_id'}
  has_many :announcements, {:foreign_key => 'user_id'}
end
