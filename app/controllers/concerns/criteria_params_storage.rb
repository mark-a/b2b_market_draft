module CriteriaParamsStorage

  extend ActiveSupport::Concern


  private


  def handle_search_params_for(id:, session_symbol:)
    used_value = (params[:set_value] || params[:range_value])
    if params[:filter] && used_value
      session[session_symbol] = session[session_symbol] || {}
      session[session_symbol][id] = session[session_symbol][id] || {}
      if session[session_symbol][id][params[:filter]]
        unless session[session_symbol][id][params[:filter]].include? used_value
          session[session_symbol][id][params[:filter]].push used_value
        end
      else
        session[session_symbol][id][params[:filter]] = [ used_value ]
      end
    end

    if params[:delete_category]
      session[session_symbol]&.dig(id, params[:delete_category])&.delete params[:delete_value]

      if session[session_symbol]&.dig(id, params[:delete_category]).empty?
        session[session_symbol]&.dig(id)&.delete params[:delete_category]
      end
    end
  end

end
