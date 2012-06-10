
class ShareController < ApplicationController
  before_filter :authenticate_user!

  def create
    access  = params[:access]

    if not access.eql? 'me' and not access.eql? 'friends'
      raise 'access must be "me" or "friends"'
    end

    url     = params[:url]
    og_tags = Hash.new

    if not url.nil?
      url = ShareHelper::sanitize_url(url)

      if not ShareHelper::is_http_url_valid(url)
        raise 'the url you give is not a valid http url'
      end

      og_tags = ShareHelper::get_opengraph_tags(url)
    else
      og_tags = JSON.parse(params[:og_tags]) rescue nil

      if og_tags.nil?
        raise 'unable to get opengraph tags; you should pass a url or a json containing the opengraph tags'
      end
    end

    if og_tags['video'].nil?
      raise 'the opengraph tags does not contain any video; if you passed an url, it means there are no og:video meta properties on the page ' 
    end

    content           = Content.new
    content.user_id   = current_user.id
    content.url       = ShareHelper::sanitize_url(og_tags['video'])
    content.post_date = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    content.source    = URI(content.url).host
    content.access    = access

    content.save

    respond_to do |format|
      format.json { render :json => {:status => 'success'} }
    end
  end
end
