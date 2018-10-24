class Trip < ApplicationRecord

    # Relationships
    belongs_to :travel_group
    has_many :transaction_details

end
