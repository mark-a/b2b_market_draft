class CompanyProfile < ApplicationRecord
  belongs_to :company
  has_one_attached :logo, dependent: :destroy

end
