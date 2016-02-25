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
	if params[:user_name] != settings['slack_name'] && params[:token]==settings['token'] then
		slack_username = params[:user_name]
		slack_text = params[:text]
		ids = tc.follower_ids().to_a
		cnt=(ids.size-1)/100+1
		users=[]
		cnt.times do
			ids_tmp = ids.pop(100)
			users_tmp = tc.users(ids_tmp)
			users.concat(users_tmp)
		end

		users.each do |user|
			tc.update("@#{user.screen_name} #{slack_username}「#{slack_text}」 #{settings['reply_text']}")
		end

		{'text'=> settings['slack_text'] }.to_json
	else
		"Illigal Request"
	end
end

