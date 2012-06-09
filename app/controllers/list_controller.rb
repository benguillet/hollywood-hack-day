class ListController < ApplicationController
  before_filter :authenticate_user!

  def index
    @videos = Content.where(:user_id => current_user.id).order()
  end
end
