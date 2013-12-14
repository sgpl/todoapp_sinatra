require 'sinatra'
require 'sinatra/reloader' if development? 
require 'slim'
require './song'

get '/' do 
	slim :home
end

get '/about' do 
	@title = "About My To Do List:"
	slim :about
end

get '/contact' do 
	@title = "Use this form to contact me"
	slim :contact
end


not_found do 
	slim :not_found
end

# get '/bet/:num/on/:roll' do 
# 	amount = params[:num].to_i
# 	roll = params[:roll].to_i
# 	dice = rand(5) + 1
# 	if roll == dice
# 		"You won #{amount*roll}"
# 	else
# 		"you lost #{amount} on #{roll}"
# 	end
# end
