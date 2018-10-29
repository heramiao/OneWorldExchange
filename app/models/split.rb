class Split < ApplicationRecord
  belongs_to :transaction
  belongs_to :user

  # Scopes
  scope :paid, -> { where.not(date_paid: nil) }
  scope :unpaid, -> { where(date_paid: nil) }

  # Validations
  validates_date :date_paid, on_or_after: :charge_date, allow_blank: true
  validates :percent_owed, numericality { less_than_or_equal_to: 100, greater_than: 0}
  # validate payee and payor are different people 
end
