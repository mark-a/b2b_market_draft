class PurchaserSearchController < ApplicationController

  def show
    node = params[:id].to_i

    if params[:filter] && (params[:set_value] || params[:range_value])
      session[:purchaser_search] = session[:purchaser_search] || {}
      session[:purchaser_search][params[:filter]] = params[:set_value] || params[:range_value]
    end

    if params[:delete_filter]
      session[:purchaser_search].delete(params[:delete_filter])
    end

    if node > 0
      @current = Search::Category.find(node)
      @children = Search::Category.where(parent_id: @current.id)

     unless @children.any?
        @content = Search::Criterium.where(category_id: @current.id)
        @select_box_options = @content.map do |criterium|
          [criterium.name, criterium.id, data_type(criterium.valuetype, criterium.divisor)]
        end
      else
        @subs = Search::Category.where(parent_id: @current.id)
      end

      @search = Search::ActiveSearch.new(session[:purchaser_search])

      search_query = nil
      @search.selection.each do |search|
        current = Search::Criterium.find(search.id)
        unless search_query
          search_query = add_condition(criterium: current, value: search.value)
        else
          search_query = search_query.or(add_condition(criterium: current, value: search.value))
        end
      end

      if search_query
        search_query = search_query.select("company_id")
                           .group(:company_id)
                           .having("count(id) >= #{ @search.selection.size}")
        profiles = search_query.records.map(&:company_id)
        @result = CompanyProfile.where(company_id: profiles).paginate(page: params[:page]).with_attached_logo
      end
    else
      redirect_to "/"
    end
  end

  private

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

  def add_condition(criterium:, value:)
    if criterium.valuetype == "range"
      search_value = (value.to_f * criterium.divisor).to_i
      Search::PurchaserCriteriaMatching
          .where(criterium_id: criterium.id)
          .where("values_from <= ?", search_value)
          .where("values_to >= ?", search_value)
    else
      Search::PurchaserCriteriaMatching.where(criterium_id: criterium.id, criterium_value: value)
    end
  end

  def search_params
    params.permit(:id, :locale, :filter, :set_value)
  end

end
