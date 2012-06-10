
class FormController < ApplicationController

  def index
    if not user_signed_in?
      #redirect_to :action => 'sign_in'
    else
      respond_to do |format|
        format.html { render :layout => 'form' }
      end
    end

    @share = params[:share]
  end

  def sign_in
    if user_signed_in?
      redirect_to :action => 'index'
    elsif params[:result] and params[:result].eql? 'success'
      session['user_return_to'] = '/form'
      redirect_to user_omniauth_authorize_path(:facebook)
    else
      respond_to do |format|
        format.html { render :layout => 'form' }
      end
    end
  end
end
