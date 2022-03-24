require "daydream"

class CompanyProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  def index

  end

  def new
    @company_profile = CompanyProfile.new
  end

  def show

  end

  def edit
    criteria
  end

  def update
    @company_profile.update(company_profile_params)
    if @company_profile.save
      redirect_to @company_profile, notice: 'Company profile was successfully updated.'
    else
       criteria
       render :edit
    end
  end

  def destroy

  end


  def image
    @company_profile = CompanyProfile.find(params[:id])
    if @company_profile && @company_profile.bg_color_hex
      send_file Rails.root.join(dream_file(@company_profile.bg_color_hex, @company_profile.id)), type: 'image/png', disposition: 'inline'
    else
      raise ActionController::RoutingError, 'Not Found'
    end
  end

  private

  def dream_file(color,seed)
    File.open(Dream.image(400,200,color,seed), 'r')
  end

  def categories
    @categories ||= Search::Category.where.not(parent_id: nil)
  end

  def criteria
    @criteria ||=  categories.map do |cat|
        [cat.id , Search::Criterium.where(category_id: cat.id).map do |criterium|
          [criterium.name, criterium.id, data_type(criterium.valuetype, criterium.divisor)]
        end]
      end.to_h
  end

  def set_profile
    @company_profile = CompanyProfile.find(params[:id])
    if @company_profile&.company_id
      @provider_matchings = Search::ProviderCriteriaMatching
                                .includes(:criterium, criterium: :category)
                                .where(company_id: @company_profile.company_id)
                                .group_by{|matching| [matching.criterium.category.id,matching.criterium_id ]}
      @purchaser_matchings = Search::PurchaserCriteriaMatching
                                .includes(:criterium, criterium: :category)
                                .where(company_id: @company_profile.company_id)
                                .group_by{|matching| [matching.criterium.category.id,matching.criterium_id ]}
    end
  end

  def company_profile_params
    params.require(:company_profile).permit(:company_name,
                                             :legal_form,
                                             :address,
                                             :phone,
                                             :contact_email,
                                             :contact_web,
                                             :bg_color_hex,
                                             :about_us,
                                             :logo)
  end

  def data_type(type, divisor = 1)
    if type == "range"
      {
          "data-type" => type,
          "data-divisor" => divisor
      }
    else
      {}
    end
  end
end
