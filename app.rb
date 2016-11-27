require 'sinatra'
require './db'

class KVStore < Sinatra::Application

  @@db = Db.new

  get '/:key' do
    key = params['key']
    timestamp = params['timestamp'] || Time.now.to_i
    @@db.fetch_val key, timestamp
  end

  post '/:key' do
    request.body.rewind
    key = params['key']
    val = request.body.read
    @@db.write_val(key, val)
  end

end
