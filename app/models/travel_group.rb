class TravelGroup < ApplicationRecord

    # Relationships
    has_many :group_members
    has_many :users, through: :group_members
    has_one :trip

    # Scopes
    scope :alphabetical, -> { order(:trip_name) }
    scope :chronological, -> { order(start_date: :desc ) }
    scope :current_trip, ->(Date.current) { where("start_date <= ? AND (end_date > ? OR end_date IS NULL)", Date.today, Date.today) }

    # Validations
    validates_presence_of :trip_name, :start_date
    validates_date :start_date, on_or_before: lambda { Date.current }
    validates_date :end_date, on_or_after: :start_date, allow_blank: true

end
