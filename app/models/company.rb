class Company < ApplicationRecord
  has_many :criteria_matchings, class_name: "::Search::CriteriaMatching"
  has_one :profile, class_name: "CompanyProfile"

  has_and_belongs_to_many :members
end
