# -*- encoding : utf-8 -*-
require 'anemone'
require 'date'

require File.expand_path("../../models/article_url", __FILE__)
require File.expand_path("../../models/article", __FILE__)

class Crawl
  CHANNEL_URLS = []

  class << self
    def run
      Anemone.crawl("http://cn.nytimes.com/", :threads => 1, :delay => 0.1, :user_agent => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.57 Safari/537.1') do |anemone| #单线程,每采集一页面休息0.1秒
        anemone.focus_crawl do |page|
          Crawl.filter_url(page.links)
        end

        # only article, ignore channel
        anemone.on_pages_like(/\/article\//) do |page|
          Crawl.process_article_page(page)
        end

        anemone.after_crawl do |pages|
          puts "OK"
        end
      end
    end

    def filter_url(urls)
      urls.select do |url|
        self.valid_url(url.to_s)
      end
    end

    def process_article_page(page)
      article = extract_page_data(page.doc, page.url)
      unless article.nil?
        article.save
        ArticleUrl.spidered!(article.url)
      end
    end

    def valid_url(url)
      if url =~ /(?!.+(\/en\/|zh-hk)$)\/(article|section)\/.*/
        if url =~ /\/section\// && !CHANNEL_URLS.include?(url)
          CHANNEL_URLS << url
          return true
        end

      if url =~ /\/article\// && valid_url_date(url) && !ArticleUrl.has?(url)
        ArticleUrl.create!(url: url)
        return true
      end
      end

      false
    end

    def valid_url_date(url)
      ( Time.now.to_date - Date.parse(url[/\d{4}\/\d{2}\/\d{2}/]) ).to_i <= 7
    end

    def extract_page_data(doc, url)
      puts "start #{url}"
      article = Article.new
      article.title = doc.css('h3.articleHeadline').text
      article.url = url.to_s
      article.category = article.url.scan(/\/article\/(\w+)\//).flatten.first
      article.published_at = Date.parse(article.url[/\d{4}\/\d{2}\/\d{2}/])
      article.article_id = (doc.css('meta[name="article_id"]').first['content'].to_i rescue nil)

      body = doc.css('#columnAB')
      body.css('#articleTab').remove
      body.css('h3.articleHeadline').remove
      body.css('div.articleTool').remove
      article.body = body.to_html
      
      article
    rescue
      puts "error #{url} - #{$!.class}: #{$!.message}"
      nil
    end
  end

end
