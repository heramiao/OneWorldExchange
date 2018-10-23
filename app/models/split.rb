class Split < ApplicationRecord

    # Validations
    validates_inclusion_of :split_type, in: %w[manual even]

end
