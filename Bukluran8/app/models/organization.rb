class Organization < ActiveRecord::Base
  belongs_to :account
  has_many :events
  has_many :event_reports
  has_many :awards
  has_many :members
  
  validates_presence_of :name
end
