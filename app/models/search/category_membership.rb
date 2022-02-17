module Search
  class CategoryMembership < ApplicationRecord
    belongs_to :category
    belongs_to :criterium_group

  end
end
