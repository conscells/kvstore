require 'influxdb'

class Db

  DB_NAME = 'store'

  def initialize
    @db = InfluxDB::Client.new DB_NAME
  end

  def fetch_val(key, timestamp)

    i = Integer(key) rescue key
    if i.is_a? Integer
      key = "#{i}"
    end

    q = "select last(value) from kv where \"key\"=%{key} and time <= %{timestamp}s"
    result = @db.query q, params: { key: key, timestamp: timestamp }

    if result.first && result.first['values'].first
      result.first['values'].first['last']
    end
  end

  def write_val(key, val)
    cur_val = fetch_val key, Time.now.to_i
    if cur_val != val
      data = {
        values: { value: val },
        tags: { key: key }
      }
      @db.write_point('kv', data, 's')
    end
  end

end
