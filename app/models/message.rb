class Message < ApplicationRecord

  validates :content, length: {maximum: 20, minimum: 2}

  belongs_to :user
  belongs_to :room
end
