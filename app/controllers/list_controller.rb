class ListController < ApplicationController
  before_filter :authenticate_user!

  def sort_video_by_hype
    @videos.sort!{ |a,b|}
  end

  def index_me
    @videos = Content.where(:user_id => current_user.id, :access => 'me').order('post_date DESC')

    respond_to do |format|
      format.html { render :template => 'list/index' }
    end
  end
  
  def index_friends
    @users  = User.where('id = :id OR (uid IN (:uid) AND provider = :provider)', {:id => current_user.id, :uid => ListHelper::get_facebook_friends_ids(current_user.access_token), :provider => 'facebook'})
    @videos = Content.includes(:user).where(:user_id => @users.map { |e| e.id }, :access => 'friends').order('post_date DESC')

    respond_to do |format|
      format.html { render :template => 'list/index' }
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
