class Split < ApplicationRecord

    # Relationships
    has_one :conversion
    has_one :transaction_detail 

    # Validations
    validates :split_type, inclusion: { in: %w[manual even] }
    validates_date :pay_date, on_or_after: :charge_date, allow_blank: true

    scope :paid,          -> { where.not(payment_receipt: nil) }

end
