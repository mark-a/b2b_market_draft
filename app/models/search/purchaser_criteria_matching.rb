module Search
  class PurchaserCriteriaMatching < ApplicationRecord
    belongs_to :company
    belongs_to :criterium
    belongs_to :criterium_value, optional: true
  end
end
