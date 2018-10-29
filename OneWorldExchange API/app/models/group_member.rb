class GroupMember < ApplicationRecord

    # Relationships
    belongs_to :user
    belongs_to :travel_group

end
