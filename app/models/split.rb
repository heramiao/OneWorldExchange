class Split < ApplicationRecord

    # Relationships
    has_one :conversion
    has_one :transaction_detail 
    belongs_to :user

    # Scopes
    scope :paid, -> { where.not(pay_date: nil) }
    scope :unpaid, -> { where(pay_date: nil) }

    # Validations
    validates :split_type, inclusion: { in: %w[manual even] }
    validates_date :pay_date, on_or_after: :charge_date, allow_blank: true
    validates :split_currency_type, inclusion: { in: %w[USD EUR GBP CHF AUD JPY TWD CNH] }

end
