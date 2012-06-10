
class ShareController < ApplicationController
  before_filter :authenticate_user!

  def create
    access  = params[:access]

    if not access.eql? 'me' and not access.eql? 'friends'
      raise 'access must be "me" or "friends"'
    end


    if params[:internal] and params[:content_id]
      old_content           = Content.where(:id => params[:content_id]).first
      
      content           = Content.new
      content.url      = old_content.url
      content.source   = old_content.source
      content.user_id  = current_user.id
    end

    if params[:url]
      url     = params[:url]

      if not url.nil?
        url = ShareHelper::sanitize_url(url)

        if not ShareHelper::is_http_url_valid(url)
          raise 'the url you give is not a valid http url'
        end
      else
        raise 'missing video url'
      end

      content           = Content.new
      content.user_id   = current_user.id
      content.source    = URI(url).host.match(/(www\.)?(.*)\.com/)[2]

      content           = Content.new
      content.user_id   = current_user.id
      content.source    = URI(url).host.match(/(www\.)?(.*)\.com/)[2]

      url = ShareHelper::sanitize_url(url)

      content.url = # change url for embed url format
      case content.source
      when 'youtube'
        hash = url.match(/^http:\/\/www.youtube.com\/watch\?v=([a-zA-Z0-9\-_]+)&?.*/)[1]
        "http://www.youtube.com/embed/#{hash}"
      when 'vimeo'
        video_id = url.match(/^http:\/\/vimeo.com\/([0-9]*)/)[1]
        "http://player.vimeo.com/video/#{video_id}"
      when 'dailymotion'
        video_id = url.match(/^http:\/\/www.dailymotion.com\/video\/([^_]+)/)[1]
        "http://www.dailymotion.com/embed/video/#{video_id}"
      end
    end

    content.post_date = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    content.access    = access

    content.save

    respond_to do |format|
      format.json { render :json => {:status => 'success'} }
    end
  end
end
