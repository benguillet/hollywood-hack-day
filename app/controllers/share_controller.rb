
class ShareController < ApplicationController
  before_filter :authenticate_user!

  def create
    access  = params[:access]

    if not access.eql? 'me' and not access.eql? 'friends'
      raise 'access must be "me" or "friends"'
    end


    if params[:internal] and params[:content_id]
      content           = Content.where(:content_id => params[:content_id]).clone
      content.user_id   = current_user.id
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

      content.url = # change url for embed url format
      case content.source
      when 'youtube'
        url.sub!(/^http:\/\/www.youtube.com\/watch\?v=/, 'http://www.youtube.com/embed/')
      when 'vimeo'
        url.sub!(/^http:\/\/vimeo.com\//, 'http://player.vimeo.com/video/')
      when 'dailymotion'
        url.sub!(/^http:\/\/www.dailymotion.com\/video\//, 'http://www.dailymotion.com/embed/video/')
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
