require 'influxdb'

class Db

  DB_NAME = 'store'
  DB_SERIES = 'kv'

  def initialize
    @db = InfluxDB::Client.new DB_NAME
  end

  def fetch_val(key, timestamp)
    result = @db.query "select last(value) from #{DB_SERIES} where \"key\"='#{key}' and time < #{timestamp}s"
    if result.first['values'].first
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
      @db.write_point(DB_SERIES, data, 's')
    end
  end

end
