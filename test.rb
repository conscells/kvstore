require 'minitest/autorun'
require './db'

class DbTest < Minitest::Test

  def setup
    @db = Db.new
  end

  def test_write
    key = 'obj'
    val = '{"hello": "world"}'
    @db.write_val key, val

    assert_equal(val, @db.fetch_val(key, Time.now.to_i))
  end

  def test_write_num_key
    key = -1
    val = '{"hello": "world"}'
    @db.write_val key, val

    assert_equal(val, @db.fetch_val(key, Time.now.to_i))
  end

  def test_fetch
  end
end
