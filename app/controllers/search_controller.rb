class SearchController < ApplicationController

  before_action :set_nav_tree


  def set_nav_tree
    @tree = Search::Category.order(parent_id: :asc, id: :asc)
  end

  def index

  end

  def criteria_values
    @values = Search::Criterium.find(params[:criterium_id].to_i).criterium_values.map{|x| [x.title,x.id]}
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: {values: @values}
        }
      end
    end
  end
end
