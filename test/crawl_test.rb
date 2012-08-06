# -*- encoding : utf-8 -*-
require File.expand_path("../helper", __FILE__)
require 'crawl'
require 'date'
require 'webmock/test_unit'
require 'open-uri'
require 'nokogiri'

class CrawlTest < Test::Unit::TestCase
  def setup
    ArticleUrl.delete_all
  end

  def test_valid_url
    assert !Crawl.valid_url("http://www.google.com")
    assert Crawl.valid_url(article_url)
    assert !Crawl.valid_url(article_url + 'en/')
    assert !Crawl.valid_url("http://cn.nytimes.com/tools/r.html?url=/article/education/2012/08/01/cc01xuhong/zh-hk/&langkey=zh-hk")
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

  def test_extract_page_data
    time = Time.now.to_date
    url = article_url(time)
    article = Crawl.extract_page_data(article_doc(url), url)
    assert_equal article.title, '德州茶党支持者有望出任参议员'
    assert_equal article.url, url
    assert_equal article.category, 'travel'
    assert_equal article.published_at, time
    assert_equal article.article_id, 1812
    assert article.body.size > 200
  end

  private
  def article_url(time = Time.now.to_date)
    "http://cn.nytimes.com/article/travel/#{time.strftime("%Y/%m/%d")}/cc26kyoto/"
  end

  def article_doc(url)
    stub_request(:any, url).to_return(:body => File.new( File.expand_path('../article.html', __FILE__) ), :status => 200)
    Nokogiri::HTML.parse(open(url), url)
  end
end
