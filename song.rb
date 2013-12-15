require 'dm-core' # main data_mapper gem
require 'dm-migrations'

configure do 
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
# this will create a file called development.db which will store all 
# the database information. 
end

configure :development do 
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

class Song
	include DataMapper::Resource # this line links song class to DataMapper which inclides the Resource module from the DataMapper gem as a mixin. 
	# this is how you make a ruby class a DataMapper resource. 
	property :id, Serial 
	property :title, String 
	property :lyrics, Text 
	property :length, Integer 
	property :released_on, Date 

	def released_on=date
		super Date.strptime(date, '%m/%d/%Y')
	end

end



DataMapper.finalize
# DataMapper.finalize is required after all classes using DataMapper to check their integrity. 


=begin 
DataMapper properties all have a type, which correspond to core ruby classes. 
String - short strings
Text - longer pieces of text
Integer - used for whole nos. 
Float - for float
Boolean - for boolean values. 
DateTime - for date and time
=end


# copying the following two get methods because songs/:id isn't getting displayed properly

get '/songs' do
	@songs = Song.all
	slim :songs
end

get '/songs/new' do
	halt(401, 'Not Authorized') unless session[:admin]
	@song = Song.new
	slim :new_song
end

get '/songs/:id' do 
	@song = Song.get(params[:id])
	slim :show_song
end

post '/songs' do 
	halt(401, 'Not Authorized') unless session[:admin]
	song = Song.create(params[:song])
	redirect to("/songs/#{song.id}")
end
# posts to the database i guess
# then creates the song w/ some id and the other specified parameters
# Redirect helper: redirects to another page. 
# to helper is an 'alias' for the url method. 

get '/songs/:id/edit' do 
	halt(401, 'Not Authorized') unless session[:admin]
	@song = Song.get(params[:id])
	slim :edit_song
end


put '/songs/:id' do 
	halt(401, 'Not Authorized') unless session[:admin]
	song = Song.get(params[:id])
	song.update(params[:song])
	redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do 
	halt(401, 'Not Authorized') unless session[:admin]
	Song.get(params[:id]).destroy
	redirect to('/songs')
end