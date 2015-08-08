require 'sinatra'
require 'json'
require 'yaml'
require 'twitter'

settings = YAML.load_file('./settings.yaml')

tc = Twitter::REST::Client.new do |conf|
	conf.consumer_key = settings['consumer_key']
	conf.consumer_secret = settings['consumer_secret']
	conf.access_token = settings['access_token']
	conf.access_token_secret = settings['access_token_secret']
end

post '/' do
	if params[:token]==settings['token']
		ids = tc.follower_ids().to_a
		cnt=(ids.size-1)/100+1
		screen_names=[]
		cnt.times do
			ids_tmp = ids.pop(100)
			screen_names_tmp = tc.users(ids_tmp)
			screen_names = push(screen_names_tmp)
		end

		screen_names.each do |name|
			tc.update("@#{name} #{settings.['reply_text']}")
		end

		{'text'=> settings.['slack_text'] }.to_json
	else
		"Illigal Request"
	end
end

