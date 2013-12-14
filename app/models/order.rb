class Order < ActiveRecord::Base
  # attr_accessible :title, :body
  self.primary_key = :user_id
  belongs_to :user
  belongs_to :driver
end
