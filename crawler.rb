#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'

agent = Mechanize.new

page = agent.get('http://kingjamesprogramming.tumblr.com')

blockquote = /<\s*blockquote\s*>(.*?)<\s*\/\s*blockquote\s*>/xm
next_page = /Older/

quotes = page.body.scan(blockquote)
i = 1
while page.link_with(:text => next_page) and i < 5
  page = agent.click(page.link_with(:text => next_page))
  quotes += page.body.scan(blockquote)
  i += 1
end

out = []
quotes.flatten.each do |quote|
  out << Nokogiri::HTML(quote.gsub(/<.*?>/,' ').gsub(/\s+/,' ').strip).text
  out << '%'
end

# TODO automatically bring to max 80 chars per line
out[0...-1].each { |line| puts line }
