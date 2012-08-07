# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require File.expand_path('../lib/database', __FILE__)
require File.expand_path('../models/article', __FILE__)

get '/' do
  "<a href='/rss.xml'>纽约时报中文网非官方Feed</a>"
end

get '/rss.xml' do
  content_type 'application/rss+xml'
  builder do |xml|
    xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "纽约时报中文网"
        xml.description "纽约时报中文网非官方Feed"
        xml.link "http://cn.nytimes.com/"

        Article.order_by(created_at: :desc).limit(50).each do |article|
          xml.item do
            xml.title article.title
            xml.link article.url
            xml.description article.body
            xml.pubDate article.published_at.rfc822()
            xml.guid article.url
          end
        end
      end
    end
  end
end
