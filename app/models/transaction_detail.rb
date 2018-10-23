class TransactionDetail < ApplicationRecord

    # Relationships
    belongs_to :split

    # Validations
    validates :expense_type, inclusion: { in: %w[food transportation shopping entertainment lodging other] }

end
