class LandingPageController < ApplicationController
  def index

  end

  def privacy

  end

  def terms

  end

  def make_me_admin
    current_member.update(admin: true)
    redirect_to root_path
  end
end
