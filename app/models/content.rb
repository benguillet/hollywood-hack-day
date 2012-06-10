class Content < ActiveRecord::Base
  attr_accessible :user_id, :url, :rate_up, :rate_down, :source
  
  belongs_to :user
end
