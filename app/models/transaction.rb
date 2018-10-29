class Transaction < ApplicationRecord
  belongs_to :travel_group
  belongs_to :trip
  has_many :splits
end
