# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler/setup'

require 'sinatra'

require File.expand_path('../lib/database', __FILE__)

get '/' do
  "Hello world, it's #{Time.now} at the server!"
end
