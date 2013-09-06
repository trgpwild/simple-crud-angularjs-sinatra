require 'sinatra'
require 'sequel'
require 'json'
require 'active_support'

DB = Sequel.sqlite('projects.db')

DB.create_table :projects do
  primary_key :id
  String :name
  String :description
  String :site
end unless DB.table_exists?(:projects)

set :public_folder, File.dirname(__FILE__) + '/public'

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/projects' do
  begin
    results = DB[:projects].all
    logger.info results.inspect
    results.to_json
  rescue
    "[]"
  end
end

post '/projects' do
  data = JSON.parse(request.body.read)
  record = DB[:projects].insert(data)
  data.to_json
end

get '/projects/:id' do |id|
  DB[:projects].where(id: id).first.to_json
end

put '/projects/:id' do |id|
  data = JSON.parse(request.body.read)
  DB[:projects].where(id: id).update(data)
  data.to_json
end

delete '/projects/:id' do |id|
  DB[:projects].where(id: id).delete
  '{"status": "success"}'
end

