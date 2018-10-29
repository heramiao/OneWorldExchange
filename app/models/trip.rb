class Trip < ApplicationRecord

    # Relationships
    belongs_to :travel_group
    has_many :transactions
end
