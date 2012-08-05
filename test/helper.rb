# -*- encoding : utf-8 -*-
require 'test/unit'

require 'rubygems'
require 'bundler/setup'

ENV['RACK_ENV'] = 'test'
require File.expand_path('../../lib/database', __FILE__)
