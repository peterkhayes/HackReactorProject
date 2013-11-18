require 'sinatra'

get '/' do
  File.read('index.html')
end