
class LandingController < ApplicationController

  def index
    if user_signed_in?
      redirect_to :controller=>'list', :action => 'index_friends'
    else
      respond_to do |format|
        format.html { render :template => 'landing/index' }
      end
    end
  end
end
