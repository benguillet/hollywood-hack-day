
class LandingController < ApplicationController

  def index
    if user_signed_in?
      redirect_to :controller=>'list', :action => 'index_friends'
    else
      #when clicking the login button
      #session['user_return_to'] = '/friends'
      #redirect_to user_omniauth_authorize_path(:facebook)
      respond_to do |format|
        format.html { render :template => 'landing/index' }
      end
    end
  end
end
