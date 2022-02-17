module Search
  class CriteriumGroup < ApplicationRecord
    has_many :criterium_group_memberships
    has_many :criteria, through: :criterium_group_memberships
  end
end

