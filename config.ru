
require 'rubygems'
require 'sinatra'
require './kstm-bot.rb'

Encoding.default_external = Encoding::UTF_8
run Sinatra::Application

