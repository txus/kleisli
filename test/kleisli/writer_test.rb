require 'test_helper'

class WriterTest < Minitest::Test
  def test_unwrap
    log, value = Writer("log", 100).unwrap
    assert_equal "log", log
    assert_equal 100, value
  end

  def test_bind
    writer = Writer("foo", 100) >-> value { Writer("bar", value + 100) }
    assert_equal Writer("foobar", 200), writer
  end

  def test_fmap
    writer = Writer("foo", 100).fmap { |value| value + 100 }
    assert_equal Writer("foo", 200), writer
  end
end
