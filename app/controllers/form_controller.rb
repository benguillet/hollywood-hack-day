
class FormController < ApplicationController

  def index
    @share = params[:share] || session[:share] || ''

    if user_signed_in?
      logger.debug current_user.inspect

      respond_to do |format|
        format.html { render :layout => 'form' }
      end
    else
      if params[:signin]
        session['user_return_to'] = '/form?share=' + URI.escape(@share)

        redirect_to user_omniauth_authorize_path(:facebook)
      else
        redirect_to '/form?signin=1&share=' + URI.escape(@share)
      end
    end
  end
end
