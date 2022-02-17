module Search
  class CriteriumGroupMembership < ApplicationRecord
    belongs_to :criterium
    belongs_to :criterium_group

  end
end
