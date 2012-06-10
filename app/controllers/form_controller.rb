
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

  end
end
