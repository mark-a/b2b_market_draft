module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def contact_link(_link)
    link = _link

    if _link
      u = URI.parse(_link)

      if (!u.scheme)
        link = "http://" + _link
      end
    end

    link
  end

end
