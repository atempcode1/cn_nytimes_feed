# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require File.expand_path('../lib/database', __FILE__)
require File.expand_path('../models/article', __FILE__)
require 'atom/pub'

get '/' do
  "Hello world, it's #{Time.now} at the server!"
end

get '/atom.xml' do
  generate_feed
end

private
def generate_feed
  feed = Atom::Feed.new do |f|
    f.title = "纽约时报中文网非官方Feed"
    f.links << Atom::Link.new(:href => "http://cn.nytimes.com/")
    f.links << Atom::Link.new(:href => "http://cn_nytimes_feed.lvcake.com/atom.xml")
    f.updated = Article.last.created_at
    f.id = "urn:uuid:9b42cffc-703d-49e0-940e-c9d05921c966"

    Article.order_by(created_at: :desc).limit(100).each do |article|
      f.entries << Atom::Entry.new do |e|
        e.title = article.title
        e.links << Atom::Link.new(:href => article.url)
        e.id = article.id.to_s
        e.updated = article.published_at
        e.content = article.body
      end 
    end
  end
  feed.to_xml
end
