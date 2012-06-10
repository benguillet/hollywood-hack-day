class ImportFbController < ApplicationController
  before_filter :authenticate_user!

  require "active_record"
  require "net/http"
  require "uri"


  USER_VIDEO_FQL_LIMIT   = 20
  FRIEND_VIDEO_FQL_LIMIT = 1
  
  FQL_QUERY_URL = 'https://api.facebook.com/method/fql.query'
  
  def access_token; @access_token ||= current_user.access_token; end
  
  
  # params is a hash
  def perform_http_get_request url, params
    uri = URI.parse(url)
    
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(params)
    http.request(request)
  end
  
  # convert json to hash
  def json_to_hash json
    as = ActiveSupport::JSON
    as.decode json.body
  end
  
  #
  def get_fql_http_request_parameters query
    {
      'format'       => 'json',
      'query'        => query,
      'access_token' => access_token.to_s
    }
  end
    
  # returns a hash with the decoded JSON result of the FQL query
  def perform_fql_query fql_query
    json_to_hash(perform_http_get_request(FQL_QUERY_URL, get_fql_http_request_parameters(fql_query)))
  end
  
  #
  def import_user_latest_shared_video_links user_id, limit
    query_string = %(
      SELECT url 
      FROM link 
      WHERE 
        owner=#{user_id=='me' ? 'me()' : user_id} 
      AND 
      (
        strpos(url,'http://www.youtube.com/watch?v=')=0 
        OR strpos(url,'http://vimeo.com/')=0 
        OR strpos(url,'http://www.dailymotion.com/video')=0
      )
      LIMIT #{USER_VIDEO_FQL_LIMIT}
    )
    query_hash = perform_fql_query(query_string)
    urls = query_hash.collect{ |row| row['url'] }
    urls.each{ |url| insert_video_into_db(url) }
  end
  
  #
  def get_friends_array
    perform_fql_query("SELECT uid2 FROM friend WHERE uid1 = me()").collect{ |row| row['uid2'].to_i }
  end
  
  #
  def import_friends_latest_shared_video_links
    get_friends_array.each do |user_id|
      import_user_latest_shared_video_links(user_id, FRIEND_VIDEO_FQL_LIMIT)
    end
  end
  
  #
  def import_user_and_friends_shared_videos
    import_user_latest_shared_video_links('me', USER_VIDEO_FQL_LIMIT)
    respond_to do |format|
      format.json { render :json => {:status => 'success'} }
    end
    
  end

  #
  def insert_video_into_db url
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
    
    content.post_date = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    content.access    = 'friends'

    content.save
  end

end