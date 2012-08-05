# -*- encoding : utf-8 -*-
class Article
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  
  field :title, type: String
  field :body, type: String
  field :url, type: String
  field :category, type: String
  field :published_at, type: Date
  field :article_id, type: Integer

  validates :title, :body, :url, presence: true
end
