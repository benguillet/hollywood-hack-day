
class LandingController < ApplicationController
  
  respond_to do |format|
    format.html { render :template => 'landing/index' }
  end
end
