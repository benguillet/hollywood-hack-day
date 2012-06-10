
class FormController < ApplicationController

  def index
    @share = params[:share] || ''

    if user_signed_in?
      respond_to do |format|
        format.html { render :layout => 'form' }
      end
    else
      redirect_to '/form/sign-in?share=' + URI.escape(@share)
    end
  end

  def sign_in
    @share   = params[:share] || ''

    if user_signed_in?
      redirect_to :action => index
    else
      if params[:success]
        session['user_return_to'] = '/form?share=' + URI.escape(@share)

        redirect_to user_omniauth_authorize_path(:facebook)
      else
        respond_to do |format|
          format.html { render :layout => 'form' }
        end
      end
    end
  end
end
