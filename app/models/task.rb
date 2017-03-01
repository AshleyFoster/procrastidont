class Task < ApplicationRecord
  attribute :time, TimeWithZone.new

  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
end
