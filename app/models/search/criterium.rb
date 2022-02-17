module Search
  class Criterium < ApplicationRecord
    has_many :criterium_values
    belongs_to :category
    has_one :criterium_group, through: :criterium_group_memberships
  end
end
