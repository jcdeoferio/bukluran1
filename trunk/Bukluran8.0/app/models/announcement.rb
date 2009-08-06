class Announcement < ActiveRecord::Base
  belongs_to :osa
    
  validates_presence_of :message
end
