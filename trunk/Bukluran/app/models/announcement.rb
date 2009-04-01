class Announcement < ActiveRecord::Base
  belongs_to :administrator
  belongs_to :osa
  #belongs_to :account
  
  validates_presence_of :message
end
