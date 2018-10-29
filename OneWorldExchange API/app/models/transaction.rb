class Transaction < ApplicationRecord

  # Relationships
  belongs_to :travel_group
  belongs_to :trip
  has_many :splits

  # Scopes
  scope :for_expense, ->(expense_type) { where(expense_type: expense_type) }
  scope :for_country, -> (country) { where(country: country) }

  # Validations
  validates :expense_type, inclusion: { in: %w[food transportation shopping entertainment lodging other] }
  validates :currency_type, inclusion: { in: %w[USD EUR GBP CHF AUD JPY TWD CNH] }
end
