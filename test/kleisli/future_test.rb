require 'test_helper'

class FutureTest < Minitest::Test
  def test_immediate_value
    assert_equal 30, Future(30).await
  end

  def test_simple_future_executes_in_parallel
    str = ""
    Future { sleep 0.1; str << "bar" }.tap {
      str << "foo"
    }.await
    assert_equal "foobar", str
  end

  def test_bind
    f = Future(30) >-> n {
      Future { n.call * 2 }
    } >-> n {
      Future { n.call * 2 } >-> m {
        Future(m.call + 2)
      }
    }
    assert_equal 122, f.await
  end

  def test_fmap
    f = Future(30).fmap { |x| x.call * 2 }
    assert_equal 60, f.await
  end
end
