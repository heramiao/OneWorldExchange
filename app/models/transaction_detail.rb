class TransactionDetail < ApplicationRecord

    # Relationships
    belongs_to :split
    belongs_to :trip

    # Scopes
    scope :for_expense, ->(expense_type) { where(expense_type: expense_type) }
    scope :for_country, -> (country) { where(country: country) }

    # Validations
    validates :expense_type, inclusion: { in: %w[food transportation shopping entertainment lodging other] }

end
