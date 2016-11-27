require 'sinatra'
require 'influxdb'

class KVStore < Sinatra::Application

  @@db = InfluxDB::Client.new 'store'
  @@series = 'kv'

  get '/:key' do
    key = params['key']
    timestamp = params['timestamp'] || Time.now.to_i
    fetch_val key, timestamp
  end

  post '/:key' do
    request.body.rewind
    key = params['key']
    val = request.body.read
    write_val(key, val)
  end

  def fetch_val(key, timestamp)
    // TODO
  end

  def write_val(key, val)
    cur_val = fetch_val key, Time.now.to_i
    puts cur_val
    puts val
    puts cur_val == val
    if cur_val != val
      data = {
        values: { value: val },
        tags: { key: key }
      }
      @@db.write_point(@@series, data, 's')
    end
  end
end
