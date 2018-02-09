require "yaml"
require "./Run"
require "../API/HelperAPI"
class Jihou
  def initialize
    @config = YAML.load_file("../Config/jihou.yml")
    puts "時報監視機構作動"
    while true
      check
      sleep 1000 * 60 # 1分おき
    end
  end

  def check
    @config.each do |key, val|
      if Time.now.strftime("%I%M") == key then
        HelperAPI::jihou(@config['chid'], val)
      end
    end
  end
end
