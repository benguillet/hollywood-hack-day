module ListHelper
  def self.get_facebook_friends_ids access_token
    fb_friend_ids = []
    fb_url        = "https://graph.facebook.com/me/friends?access_token=#{access_token}"

    begin
      begin
        response = RestClient.get(fb_url)
      rescue RestClient::BadRequest => e
        raise "FacebookAPI error: #{e.inspect}"
      rescue => e
        raise "FacebookAPI error: #{e.message}"
      end

      if response == ''
        raise 'FacebookAPI error: received empty response'
      end

      response_hash = JSON.parse(response)

      if response_hash.has_key? 'error'
        raise "FacebookAPI error : #{response_hash['error']['message']}"
      end

      response_hash["data"].each do |fb_friend|
        fb_friend_ids << (Integer(fb_friend['id']) rescue nil)
      end

      fb_url = response_hash['paging']['next']
    end while not response_hash.nil? and not response_hash['data'].nil? and response_hash['data'].size > 0

    return fb_friends_ids
  # rescue => e
  #   return []
  end
end
