# AIzaSyArJ1GmWqCEDDV7tY5ySIHUkKxeaYu1fgs <--- v3APIKey
require 'google/apis/youtube_v3'

GOOGLE_API_KEY = 'AIzaSyArJ1GmWqCEDDV7tY5ySIHUkKxeaYu1fgs'

class YoutubeHelper
  class << self
    def ytsearch(query)
      service = Google::Apis::YoutubeV3::YouTubeService.new
      # APIキーを設定
      service.key = GOOGLE_API_KEY
      # 取得する検索結果のオプションを指定
      option = {
        # 検索ワードの指定
          q: query,
          # 検索対象のタイプの指定(video, channel, playlistが使える)
          type: 'video',
          # 返される検索結果の最大数を指定
          max_results: 1
      }

      # 検索結果を取得
      results = service.list_searches(:snippet, option)
      # タイトル, IDを出力
      title = results.items[0].snippet.title
      id = results.items[0].id.video_id
      return [title, id]
    end
  end
end
