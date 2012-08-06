# -*- encoding : utf-8 -*-
class ArticleUrl
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :url, type: String
  field :spidered, type: Boolean, default: false

  validates :url, presence: true

  def self.has?(url)
    self.where(url: url).exists?
  end

  def self.spidered!(url)
    article_url = self.where(url: url).first
    article_url.update_attribute(:spidered, true) unless article_url.nil?
  end
end
