#! /usr/bin/env ruby

require 'uri'
require 'net/http'
require 'rss'

ICON = '📡'.freeze

# Please uncommentout the genre you like
FEED_URLS = [
  # # entry
  # 'http://feeds.feedburner.com/hatena/b/hotentry',
  # 'http://b.hatena.ne.jp/entrylist.rss',

  # # social
  # 'http://b.hatena.ne.jp/hotentry/social.rss',
  # 'http://b.hatena.ne.jp/entrylist/social.rss',

  # # economics
  # 'http://b.hatena.ne.jp/hotentry/economics.rss',
  # 'http://b.hatena.ne.jp/entrylist/economics.rss',

  # # life
  # 'http://b.hatena.ne.jp/hotentry/life.rss',
  # 'http://b.hatena.ne.jp/entrylist/life.rss',

  # # knowledge
  # 'http://b.hatena.ne.jp/hotentry/knowledge.rss',
  # 'http://b.hatena.ne.jp/entrylist/knowledge.rss',

  # # it
  # 'http://b.hatena.ne.jp/hotentry/it.rss',
  # 'http://b.hatena.ne.jp/entrylist/it.rss',

  # # entertainment
  # 'http://b.hatena.ne.jp/hotentry/entertainment.rss',
  # 'http://b.hatena.ne.jp/entrylist/entertainment.rss',

  # # game
  # 'http://b.hatena.ne.jp/hotentry/game.rss',
  # 'http://b.hatena.ne.jp/entrylist/game.rss',

  # # fun
  # 'http://b.hatena.ne.jp/hotentry/fun.rss',
  # 'http://b.hatena.ne.jp/entrylist/fun.rss',

  # # video
  # 'http://feeds.feedburner.com/hatena/b/video',
].freeze

def feeds
  FEED_URLS.map do |url|
    parsed_url = URI.parse(url)
    { header: generate_header(parsed_url), items: fetch_feed(parsed_url).items }
  end
end

def generate_header(uri)
  name = uri.path.gsub(/\A\/|\.\w+\z/, '').split('/').join('_')
  url = uri.to_s.gsub(/\.\w+\z/, '')
  { name: name, url: url }
end

def fetch_feed(uri)
  option = { 'user-agent' => 'Chrome/54.0.2840.98' }
  response = Net::HTTP.start(uri.host) do |http|
    http.get(uri.path, option)
  end

  RSS::Parser.parse(response.body)
end

def print(feed)
  puts "#{feed[:header][:name]} | href=#{feed[:header][:url]}"
  feed[:items].each do |item|
    title = item.title.gsub('|', '/')
    puts "--#{title} | href=#{item.link}"
  end
end

# --------------------------------------
# Display
# --------------------------------------
puts ICON
puts '---'
feeds.each { |feed| print(feed) }
puts '---'
puts 'reload | color=red refresh=true'

