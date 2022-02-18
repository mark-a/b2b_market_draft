class CriteriaUploadController < ApplicationController
  before_action :authenticate_member!

  # matches 2times formats : 30 1/2 , 30,5 , 30.5 divided by dash
  #match = params[:set_value].match /^(\d*\s*\d+[\.,\/]?\d*)+\s*-\s*(\d*\s*\d+[\.,\/]?\d*)+$/
  #if match
  #from = (match.captures[0].gsub(",",".").to_r.to_f * criterium.divisor).ceil.to_i
  #to = (match.captures[1].gsub(",",".").to_r.to_f * criterium.divisor).floor.to_i
  #end

  def add_provider
    if params[:filter].present?
      criterium = Search::Criterium.find_by(id: params[:filter])
      if criterium
        if criterium.valuetype == "set"
          add_values(criterium, Search::ProviderCriteriaMatching)
        elsif criterium.valuetype == "range"
          add_range(criterium, Search::ProviderCriteriaMatching)
        end
      end
      redirect_to edit_company_profile_path(id: params[:profile_id]), notice: "Criterium added"
    end
  end

  def add_purchaser
    if params[:filter].present?
      criterium = Search::Criterium.find_by(id: params[:filter])
      if criterium
        if criterium.valuetype == "set"
          add_values(criterium, Search::PurchaserCriteriaMatching)
        elsif criterium.valuetype == "range"
          add_range(criterium, Search::PurchaserCriteriaMatching)
        end
      end
      redirect_to edit_company_profile_path(id: params[:profile_id]), notice: "Criterium added"
    end
  end

  private

  def add_range(criterium, klass)
    from = (params[:range_from].gsub(",", ".").to_r.to_f * criterium.divisor).ceil.to_i
    to = (params[:range_to].gsub(",", ".").to_r.to_f * criterium.divisor).floor.to_i
    company = CompanyProfile.find(params[:profile_id]).company
    klass.find_or_create_by(company_id: company.id,
                            criterium_id: criterium.id,
                            values_from: from,
                            values_to: to)
  end

  def add_values(criterium, klass)
    params[:set_value].each do |new_value|
      crit_value = Search::CriteriumValue.find_by(id: new_value)
      company = CompanyProfile.find(params[:profile_id]).company
      klass.find_or_create_by(company_id: company.id,
                              criterium_id: criterium.id,
                              criterium_value_id: crit_value.id)
    end
  end
end
