# if windows {
::RBNACL_LIBSODIUM_GEM_LIB_PATH = 'C:/Ruby23-x64/libsodium/libsodium.dll' # 音声のライブラリパス
# }

require "./API/Youtube"
require "./API/Niconico"
require "./API/HelperAPI"
require "discordrb"
require "yaml"
require "restclient"
require "nokogiri"
require "kconv"
require "rubygems"
require "bundler/setup"

BOTSTATS = File.open("config/bot.yml") { |file| YAML.load(file) }

def get_token()
  BOTSTATS["token"]
end

def get_client_id()
  BOTSTATS["client_id"]
end

def get_prefix()
  BOTSTATS["prefix"]
end

TOKEN = get_token
CLIENT_ID = get_client_id
PREFIX = get_prefix
NOT_IMPL = "まだ実装されていません。"

bot = Discordrb::Commands::CommandBot.new(token: TOKEN, client_id: CLIENT_ID, prefix: PREFIX)
#jihou = Jihou.new

bot.command(:dice, min_args: 1) do |event, men|
  event << HelperAPI.decode_escape(NOT_IMPL)
end

bot.command(:ytsearch, min_args: 1) do |event, *query|
    p query
    result = YoutubeHelper::ytsearch(query.join(' '))
    # 結果を出力
    event.respond(result[0])
    event.respond("https://youtube.com/watch?v=#{result[1]}") # 動画ID
end

bot.command(:ncsearch) do |event|
  event << HelperAPI.decode_escape("ニコニコ動画の検索")
  event << HelperAPI.decode_escape(NOT_IMPL)
end

bot.command(:shindan, min_args: 2) do |event, id, *name| # 診断メーカー
    domain = "http://shindanmaker.com/#{id}"
    begin
      resp = HelperAPI::get_response(domain, name.join(" "))
    rescue => e
      event << "```\n#{$!}\n```"
      return
    end

    if resp.nil? then
      event << "```\n#{$@}\n```"
      event << HelperAPI.decode_escape("診断できませんでした。もう一度お試しください。")
      return
    end
    event << "#{resp}"
end
  
bot.command(:meshiyosoi, min_args: 1) do |event, *name| # 飯よそい
    domain = "http://shindanmaker.com/80808"
    begin
      resp = HelperAPI::get_response(domain, name.join(" "))
    rescue => e
      event << "```\n#{$!}\n```"
      return
    end

    if resp.nil? then
      event << "```\n#{$@}\n```"
      event << HelperAPI.decode_escape("診断できませんでした。もう一度お試しください。")
      return
    end
    event << "#{resp}"
end

bot.command(:http) do |event, domain|
  begin
    resp = RestClient.get(domain)
    puts resp.code
    event << "#{domain} -> #{resp.code}"
  rescue RestClient::BadRequest => e
    puts event << "#{domain} -> #{400}"
    event << "#{domain} -> #{400}"
  rescue ::SocketError => e
    puts "#{domain} -> #{404}"
    event << "#{domain} -> #{404}"
  end
end

bot.command(:play, min_args: 2, max_args: 2) do |event, service, id|
  service_url = "https://"
  case service
  when "youtube"
    service_url = "youtube.com/watch/?v=#{id}"
    event << service_url
    break
  when "niconico"
    service_url = "nicovideo.jp/watch/"
    service_url += id.start_with?("sm") ? "" : "sm"
    service_url += "#{id}"
    w = NiconicoHepler::get_video(id.to_i)
    p w
    event << service_url
    break
  when "soundcloud" # id => author/id
    if id =~ /[\w]+\/[\w]+/ then
      service_url = "soundcloud.com/#{id}"
      event << service_url
    else
      event << HelperAPI.decode_escape("SoundCloudを利用する場合は`author/bgm名`の形式で入力してください。")
      return
    end
    break
  when "bilibili"
    event << HelperAPI.decode_escape(NOT_IMPL)
    break
  else
    event << HelperAPI.decode_escape("不明なサービス名")
  end
end

bot.command(:invite) do |event|
  event << HelperAPI.decode_escape(NOT_IMPL)
end

bot.command(:exit, help_avaiable: false) do |event|
  event << "Leaving"
  exit(-37)
end

bot.ready do |event|
  bot.game = "Type #{PREFIX}help"
  puts "READY"
end

bot.run # TODO: Ayncにして時報
