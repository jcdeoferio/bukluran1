class Event < ActiveRecord::Base
  belongs_to :organization
  
  validates_presence_of :name, :message => "of activity can't be blank"
end
