require 'discordrb'
require "yaml"
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

bot.command :hello do |event|
 event.send_message("hallo,world.#{event.user.name}")
end

bot.run
