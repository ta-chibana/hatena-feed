#! /usr/bin/env ruby

require 'uri'
require 'net/http'
require 'rss'

ICON = '📡'.freeze
FEED_URLS = [
  # 総合
  'http://feeds.feedburner.com/hatena/b/hotentry',
  'http://b.hatena.ne.jp/entrylist.rss',

  # 世の中
  'http://b.hatena.ne.jp/hotentry/social.rss',
  'http://b.hatena.ne.jp/entrylist/social.rss',

  # 政治と経済
  'http://b.hatena.ne.jp/hotentry/economics.rss',
  'http://b.hatena.ne.jp/entrylist/economics.rss',

  # 暮らし
  'http://b.hatena.ne.jp/hotentry/life.rss',
  'http://b.hatena.ne.jp/entrylist/life.rss',

  # 学び
  'http://b.hatena.ne.jp/hotentry/knowledge.rss',
  'http://b.hatena.ne.jp/entrylist/knowledge.rss',

  # テクノロジー
  'http://b.hatena.ne.jp/hotentry/it.rss',
  'http://b.hatena.ne.jp/entrylist/it.rss',

  # エンタメ
  'http://b.hatena.ne.jp/hotentry/entertainment.rss',
  'http://b.hatena.ne.jp/entrylist/entertainment.rss',

  # アニメとゲーム
  'http://b.hatena.ne.jp/hotentry/game.rss',
  'http://b.hatena.ne.jp/entrylist/game.rss',

  # おもしろ
  'http://b.hatena.ne.jp/hotentry/fun.rss',
  'http://b.hatena.ne.jp/entrylist/fun.rss',

  # 動画
  'http://feeds.feedburner.com/hatena/b/video',
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
  puts "#{feed[:header][:name]}|href=#{feed[:header][:url]}"
  feed[:items].each do |item|
    puts "--#{item.title} | href=#{item.link}"
  end
end

# --------------------------------------
# Display
# --------------------------------------
puts ICON
puts '---'
feeds.each { |feed| print(feed) }

