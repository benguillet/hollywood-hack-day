class ListController < ApplicationController
  before_filter :authenticate_user!

  def index_me
    @videos = Content.where(:user_id => current_user.id, :access => 'me').order('post_date DESC')
  end
  
  def index_friends
    @friends = User.where(:uid => ListHelper::get_facebook_friends_ids(current_user.access_token), :provider => 'facebook')
    @videos  = Content.includes(:users).where(:user_id => @friends.map { |e| e.id }, :access => 'friends').order('post_date DESC')
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
