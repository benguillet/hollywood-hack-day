class ListController < ApplicationController
  before_filter :authenticate_user!, :instantiate_controller_and_action_names
 
  def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
  end

  def index_me
    if params[:before]
      query = Content.where('user_id = :user_id AND access = :access AND post_date < :post_date', {:user_id => current_user.id, :access => 'me', :post_date => Time.at(Integer(params[:before])).getutc.strftime('%Y-%m-%d %H:%M:%S')})
    elsif params[:after]
      query = Content.where('user_id = :user_id AND access = :access AND post_date > :post_date', {:user_id => current_user.id, :access => 'me', :post_date => Time.at(Integer(params[:after])).getutc.strftime('%Y-%m-%d %H:%M:%S')})
    else
      query = Content.where(:user_id => current_user.id, :access => 'me')
    end

    # @videos = query.order('DATE(post_date) DESC, rate_up-(rate_down*1.5) DESC').limit(5)
    @videos = query.order('post_date DESC').limit(5)

    if @videos.empty? and (params[:before] or params[:after])
      redirect_to '/me'
    else    
      respond_to do |format|
        format.html { 
          if request.xhr?
            render :template => 'list/index', :layout => nil
          else
            render :template => 'list/index'
          end
        }
      end
    end
  end
  
  def index_friends
    @users  = User.where('id = :id OR (uid IN (:uid) AND provider = :provider)', {:id => current_user.id, :uid => ListHelper::get_facebook_friends_ids(current_user.access_token).map { |e| e.to_s }, :provider => 'facebook'})

    if params[:before]
      query = Content.where('user_id IN (:user_id) AND access = :access AND post_date < :post_date', {:user_id => @users.map { |e| e.id }, :access => 'friends', :post_date => Time.at(Integer(params[:before])).getutc.strftime('%Y-%m-%d %H:%M:%S')})
    elsif params[:after]
      query = Content.where('user_id IN (:user_id) AND access = :access AND post_date > :post_date', {:user_id => @users.map { |e| e.id }, :access => 'friends', :post_date => Time.at(Integer(params[:after])).getutc.strftime('%Y-%m-%d %H:%M:%S')})
    else
      query = Content.where(:user_id => @users.map { |e| e.id }, :access => 'friends')
    end

    # @videos = query.includes(:user).order('DATE(post_date) DESC, rate_up-(rate_down*1.5) DESC').limit(5)
    @videos = query.includes(:user).order('post_date DESC').limit(5)

    if @videos.empty? and (params[:before] or params[:after])
      redirect_to '/friends'
    else
      respond_to do |format|
        format.html { 
          if request.xhr?
            render :template => 'list/index', :layout => nil
          else
            render :template => 'list/index'
          end
        }
      end
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
