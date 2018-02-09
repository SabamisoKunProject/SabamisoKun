require "nokogiri"
require "restclient"

class SoundCloudHelper
  class << self
    def search(query, many = 10)
      url = "https://soundcloud.com/search?q=#{CGI.escape(query)}"
      html = RestClient.get(url)
      doc = Nokogiri::HTML.parse(html, nil, 'utf-8')
      meta = []
      contents = []
      i = 0
      puts url
      target_class = "div > a > span" #"* > a.soundTitle_title.sc-link-dark"
      puts target_class
      p doc.css(target_class)
      for i in 0...many
        puts i
        next if doc.css(target_class).nil?

        meta[:href] = doc.css(target_class)[i][:href]

        meta[:name] = doc.css("#{target_class} > span")[i].text

        contents.push(meta)
      end

      contents
    end
  end
end
