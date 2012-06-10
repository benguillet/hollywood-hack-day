class ListController < ApplicationController
  before_filter :authenticate_user!

  def index
    @videos = Content.where(:user_id => current_user.id).order()
    
    @videos.each do |video|
      $stderr.puts video.url
    end
  end
  
  def rate_up
    content_id  = params[:content_id]
    content = Content.where(:id => content_id).first
    if !content.nil?
      content.increment!(:rate_up)
    else
      raise "trying to rate_up a content that does not exit, id = #{content_id}"
    end
    respond_to do |format|
      format.json { render :json => {:status => 'success'} }
    end
  end  
  
  def rate_down
    content_id  = params[:content_id]
    content = Content.where(:id => content_id).first
    if !content.nil?
      content.increment!(:rate_down)
    else
      raise "trying to rate_down a content that does not exit, id = #{content_id}"
    end
    respond_to do |format|
      format.json { render :json => {:status => 'success'} }
    end
  end  
end
