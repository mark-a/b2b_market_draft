module SearchHelper
  def base_site_params
    base = params.permit(:id,:button,:authenticity_token,:new_search => {}, :search => {})
    base[:search] =  base[:search]&.reject{|_, v| v.blank?}
    base
  end
end
