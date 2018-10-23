class Split < ApplicationRecord

    # Relationships
    has_one :conversion
    has_one :transaction_detail 

    # Validations
    validates :split_type, inclusion: { in: %w[manual even] }

end
