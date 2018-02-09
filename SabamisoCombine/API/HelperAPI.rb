class HelperAPI
  class << self
    # 実例: \u30A7 =>ェ
    def decode_escape(s)
      s.gsub(/\\u([\da-fA-F]{4})/) { [$1].pack('H*').unpack('n*').pack('U*') }
    end

    def get_response(uri, name)
      RestClient.post(uri, {'u' => name}, {}) do |response, request, result, &block|
        case response.code
        when 301, 302, 307
          redirected_url = response.headers[:location]
          get_response(redirected_url, name)
        when 400..499, 500..599
          nil
        else
          html = Nokogiri::HTML.parse(response.toutf8, nil, 'utf-8')
          html.css('div.result2')[0].css('div')[0].content.strip
        end
      end
    end

    def jihou(channel_id, text)
      Discordrb::Cache.channel(channel_id).send(text)
    end
  end # clase
end
