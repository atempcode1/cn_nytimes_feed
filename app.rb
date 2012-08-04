require 'rubygems'
require 'bundler/setup'

require 'sinatra'

get '/' do
  "Hello world, it's #{Time.now} at the server!"
end
