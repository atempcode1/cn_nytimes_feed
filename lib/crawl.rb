# -*- encoding : utf-8 -*-
require 'anemone'

require File.expand_path("../../models/article_url", __FILE__)

class Crawl
  CHANNEL_URLS = []

  def self.run
    Anemone.crawl("http://cn.nytimes.com/") do |anemone|
      anemone.focus_crawl do |page|
        Crawl.filter_url(page.links)
      end

      # only article, ignore channel
      anemone.on_pages_like(/\/article\//) do |page|
        Crawl.process_article_page(page)
      end

      anemone.after_crawl do |pages|
        puts "OK: #{pages.uniq.size}"
      end
    end
  end

  def self.filter_url(urls)
    urls.select do |url|
      self.valid_url(url.to_s)
    end
  end

  def self.process_article_page(page)
    
  end

  def self.valid_url(url)
    if url =~ /(?!.+\/en\/$)\/(article|section)\/.*/
      if url =~ /\/section\// && !CHANNEL_URLS.include?(url)
        CHANNEL_URLS << url
        return true
      end

      if url =~ /\/article\// && !ArticleUrl.has?(url)
        ArticleUrl.create!(url: url)
        return true
      end
    end

    false
  end
  
end
