class CriteriaUploadController < ApplicationController
  before_action :authenticate_member!

  # matches 2times formats : 30 1/2 , 30,5 , 30.5 divided by dash
  #match = params[:set_value].match /^(\d*\s*\d+[\.,\/]?\d*)+\s*-\s*(\d*\s*\d+[\.,\/]?\d*)+$/
  #if match
  #from = (match.captures[0].gsub(",",".").to_r.to_f * criterium.divisor).ceil.to_i
  #to = (match.captures[1].gsub(",",".").to_r.to_f * criterium.divisor).floor.to_i
  #end

  def add_provider
    if params[:filters].present?
      params[:filters].each do |tuple|
        criterium_id, value = tuple.split(";")
        criterium = Search::Criterium.find_by(id: criterium_id)
        add_criterium(criterium, value, value, Search::ProviderCriteriaMatching, params[:company_id])
      end
      redirect_back fallback_location: root_path
    elsif params[:filter].present?
      criterium = Search::Criterium.find_by(id: params[:filter])
      company = CompanyProfile.find(params[:profile_id]).company
      if params[:set_value]
        add_criterium(criterium, params[:set_value], nil, Search::ProviderCriteriaMatching, company.id)
      else
        add_criterium(criterium, params[:range_from], params[:range_to], Search::ProviderCriteriaMatching, company.id)
      end
      redirect_to edit_company_profile_path(id: params[:profile_id]), notice: "Criterium added"
    end
  end

  def add_purchaser
    if params[:filters].present?
      params[:filters].each do |tuple|
        criterium_id, value = tuple.split(";")
        criterium = Search::Criterium.find_by(id: criterium_id)
        add_criterium(criterium, value, value, Search::PurchaserCriteriaMatching, params[:company_id])
      end
      redirect_back fallback_location: root_path
    elsif params[:filter].present?
      criterium = Search::Criterium.find_by(id: params[:filter])
      company = CompanyProfile.find(params[:profile_id]).company
      if params[:set_value]
        add_criterium(criterium, params[:set_value], nil, Search::PurchaserCriteriaMatching, company.id)
      else
        add_criterium(criterium, params[:range_from], params[:range_to], Search::PurchaserCriteriaMatching, company.id)
      end
      redirect_to edit_company_profile_path(id: params[:profile_id]), notice: "Criterium added"
    end
  end

  private

  def add_criterium(criterium, value, second_value, model, company_id)
    if criterium
      if criterium.valuetype == "set"
        add_value(criterium, model, value, company_id)
      elsif criterium.valuetype == "range"
        add_range(criterium, model, value, second_value, company_id)
      end
    end
  end

  def add_range(criterium, klass, range_from, range_to, company_id)
    from = (range_from.gsub(",", ".").to_r.to_f * criterium.divisor).ceil.to_i
    to = (range_to.gsub(",", ".").to_r.to_f * criterium.divisor).floor.to_i
    klass.find_or_create_by(company_id: company_id,
                            criterium_id: criterium.id,
                            values_from: from,
                            values_to: to)
  end

  def add_value(criterium, klass, set_value, company_id)
    crit_value = Search::CriteriumValue.find_by(id: set_value)
    klass.find_or_create_by(company_id: company_id,
                            criterium_id: criterium.id,
                            criterium_value_id: crit_value.id)
  end
end
