# -*- encoding : utf-8 -*-
require File.expand_path("../helper", __FILE__)
require 'crawl'

class CrawlTest < Test::Unit::TestCase
  def setup
    ArticleUrl.delete_all
  end

  def test_valid_url
    assert !Crawl.valid_url("http://www.google.com")
    assert Crawl.valid_url("http://cn.nytimes.com/article/business/2012/08/04/c04europe/")
    assert !Crawl.valid_url("http://cn.nytimes.com/article/business/2012/08/04/c04europe/en/")
    assert Crawl.valid_url("http://cn.nytimes.com/section/world/")
  end

  #频道url重复时返回false
  def test_valid_url_channel
    assert Crawl.valid_url("http://cn.nytimes.com/section/china/")
    assert !Crawl.valid_url("http://cn.nytimes.com/section/china/")
  end

  #文章url重复时返回false
  def test_valid__url_article
    assert Crawl.valid_url("http://cn.nytimes.com/article/travel/2012/07/25/cc26kyoto/")
    assert !Crawl.valid_url("http://cn.nytimes.com/article/travel/2012/07/25/cc26kyoto/")
  end
end
