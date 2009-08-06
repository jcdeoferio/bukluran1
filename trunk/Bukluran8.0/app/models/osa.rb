class Osa < ActiveRecord::Base  
  belongs_to :account
  has_many :announcements
end
