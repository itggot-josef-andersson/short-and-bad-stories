require('sinatra')
require('sqlite3')
require('uri')

require_relative 'db_connection'
require_relative 'story_data'

db = DBConnection.new

set :bind, '0.0.0.0'

get '/' do
  erb :home
end

get '/latest' do
  @title = 'Latest stories'
  @stories = db.latest_stories
  erb :story_list
end

get '/read/:hash' do |hash|
  @story_data = db.get_story_data_from_hash hash
  if @story_data
    @text = IO.read("./stories/#{hash}")
    puts "\n\nThe text to print is: '#{@text}'"
    erb :read
  else
    @dir = request.path_info
    erb :'404'
  end
end

get '/share' do
  if params['thethingthatdidnotwork']

  end
  erb :upload
end

get '/process_share' do
  redirect '/share'
end

post '/process_share' do
  title = params['title']
  text = params['text']
  if title
    if text
      text = URI.decode(URI.encode(URI.unescape(text).gsub(%r{</?[^>]+?>}, '')).gsub('%0A', '<br>')).gsub(%r{((<br>){3,})}, '<br><br>') #%0A
      if title.length > 3
        if title.length < 500
          if title.match '([^a-zA-Z0-9\(\)%!?+\'"\[\]\{\}_:, -].+)'
            redirect '/share?thethingthatdidnotwork=titlecannotcontainallthelittlecharactersthatyoutried'
          else
            if text.length > 10
              if text.length < 20000
                hash = db.upload_story title, text
                if hash
                  redirect "/read/#{hash}"
                else
                  redirect '/share?thethingthatdidnotwork=ehhhidontreallyknowwhatswrongbutihopeitsnothingseriousmaybeitwillworkifyoutryagain'
                end
              else
                redirect '/share?thethingthatdidnotwork=textwastoolongwecanonlyhandle20kchars'
              end
            else
              redirect '/share?thethingthatdidnotwork=textwasactuallytooshortevenforthisretardedsite'
            end
          end
        else
          redirect '/share?thethingthatdidnotwork=titlewastoolongwecanonlyhandle500chars'
        end
      else
        redirect '/share?thethingthatdidnotwork=titlewastoshort'
      end
    else
      redirect '/share?thethingthatdidnotwork=thetextthingismissing'
    end
  else
    redirect '/share?thethingthatdidnotwork=thetitlethingismissing'
  end
end

get '/res/:key' do |key|
  contentType = ''
  path = ''
  if key == 'style'
    contentType = 'text/css'
    path = './style/style.css'
  elsif key == 'upload_script'
    contentType = 'application/javascript'
    path = './scripts/upload.js'
  end
  headers({'Content-Type' => contentType})
  get_file_contents path
end

get '/favicon.ico' do
  headers({'Content-Type' => 'image/x-icon'})
  get_file_contents './favicon.ico'
end

get // do
  @dir = request.path_info
  erb :'404'
end

post // do
  @dir = request.path_info
  erb :'404'
end

def get_file_contents(src)
  out = ''
  file = File.new(src, 'r')
  while (line = file.gets)
    out += line
  end
  out
end