class Split < ApplicationRecord
  belongs_to :settlement, foreign_key: :transactions_id, class_name: 'Transaction'
  belongs_to :payee, foreign_key: :payee_id, class_name: 'User'
  belongs_to :payor, foreign_key: :payor_id, class_name: 'User'

  # Scopes
  scope :paid, -> { where.not(date_paid: nil) }
  scope :unpaid, -> { where(date_paid: nil) }

  # Validations
  validates_date :date_paid, on_or_after: :date_charged, allow_blank: true
  validates_numericality_of :percent_owed, :less_than_or_equal_to => 100, :greater_than => 0 
  # validate payee and payor are different people 
end
