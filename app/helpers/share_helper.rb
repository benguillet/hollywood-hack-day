module ShareHelper

  def self.sanitize_url url
    if not url =~ /^[a-zA-Z]+:\/\//
      url = 'http://' + url
    end

    url = url.gsub(/[^a-z0-9\-~+_.?\[\]\^#=!&;,\/:%@$\|*\'"()\x80-\xff]/i, '')
    url = url.gsub(';//', '://')
    url = url.gsub('&amp;', '&')

    return url
  end

  def self.is_http_url_valid url
    return url =~ /^(https?):\/\/(?#)((([a-z0-9][a-z0-9-]*[a-z0-9]\.)*(?#)[a-z][a-z0-9-]*[a-z0-9](?#)|((\d|[1-9]\d|1\d{2}|2[0-4][0-9]|25[0-5])\.){3}(?#)(\d|[1-9]\d|1\d{2}|2[0-4][0-9]|25[0-5])(?#))(:\d+)?(?#))(((\/+([a-z0-9$_\.\+!\*\'\(\),;:@&=-]|%[0-9a-f]{2})*)*(?#)(\?([a-z0-9$_\.\+!\*\'\(\),;:@&=-]|%[0-9a-f]{2})*)(?#)?)?)?(?#)(#([a-z0-9$_\.\+!\*\'\(\),;:@&=-]|%[0-9a-f]{2})*)?(?#)$/i
  end

  def self.get_url_content url
    Rails.logger.debug "Fetch url #{url.inspect}"

    response = Rails.cache.fetch('URL' + Digest::MD5.hexdigest(url)) do
      RestClient.get(url)
    end

    Rails.logger.debug "Fetch url, response type: #{response.class.name}"

    return response
  rescue => e
    Rails.logger.error "Unable to get url content for #{method(__method__).parameters.map { |arg| [arg[1], eval(arg[1].to_s)] }.to_json}: #{e.message}"

    raise e
  end

  def self.get_opengraph_tags url
    tags = Rails.cache.fetch('OG-' + Digest::MD5.hexdigest(url)) do
      html      = ShareHelper::get_url_content(url)
      og_values = Hash.new

      Nokogiri::HTML.parse(html, nil, 'UTF8').css('meta').each do |m|
        if m.attribute('property') and m.attribute('property').to_s =~ /^og:(.+)$/i
          key   = m.attribute('property').value[3..-1]
          value = m.attribute('content').to_s

          og_values[key] = value
        end
      end

      og_values
    end

    Rails.logger.debug "OpenGraph tags for #{url.inspect}: #{tags.inspect}"

    return tags
  rescue => e
    Rails.logger.error "Unable to get OpenGraph tags for #{method(__method__).parameters.map { |arg| [arg[1], eval(arg[1].to_s)] }.to_json}: #{e.message}"

    return Hash.new, false
  end
end
