# -*- encoding : utf-8 -*-
require File.expand_path("../helper", __FILE__)
require 'crawl'
require 'date'

class CrawlTest < Test::Unit::TestCase
  def setup
    ArticleUrl.delete_all
  end

  def test_valid_url
    assert !Crawl.valid_url("http://www.google.com")
    assert Crawl.valid_url(article_url)
    assert !Crawl.valid_url(article_url + 'en/')
    assert Crawl.valid_url("http://cn.nytimes.com/section/world/")
  end

  #频道url重复时返回false
  def test_valid_url_channel
    assert Crawl.valid_url("http://cn.nytimes.com/section/china/")
    assert !Crawl.valid_url("http://cn.nytimes.com/section/china/")
  end

  #文章url重复时返回false
  def test_valid_url_article
    assert Crawl.valid_url(article_url)
    assert !Crawl.valid_url(article_url)
  end

  #一周前的文章返回false
  def test_valid_url_article_date
    today = Time.now.to_date
    a_week_ago = today - 8
    assert Crawl.valid_url(article_url(today))
    assert !Crawl.valid_url(article_url(a_week_ago))
  end

  def test_valid_url_date
    assert Crawl.valid_url_date(article_url)
    assert !Crawl.valid_url_date(article_url(Time.now.to_date - 8))
  end

  private
  def article_url(time = Time.now.to_date)
    "http://cn.nytimes.com/article/travel/#{time.strftime("%Y/%m/%d")}/cc26kyoto/"
  end
end
