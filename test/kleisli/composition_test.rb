require 'test_helper'

class CompositionTest < Minitest::Test
  def test_one_method
    f = F . first
    result = f.call([1])
    assert Fixnum === result, "#{result} is not a number"
    assert_equal 1, result
  end

  def test_two_methods
    f = F . first . last
    result = f.call([1, [2,3]])
    assert Fixnum === result, "#{result} is not a number"
    assert_equal 2, result
  end

  def test_one_function
    my_first = lambda { |x| x.first }

    f = F . fn(&my_first)
    result = f.call([1])
    assert Fixnum === result, "#{result} is not a number"
    assert_equal 1, result
  end

  def test_two_functions
    my_first = lambda { |x| x.first }
    my_last = lambda { |x| x.last }

    f = F . fn(&my_first) . fn(&my_last)
    result = f.call([1, [2,3]])
    assert Fixnum === result, "#{result} is not a number"
    assert_equal 2, result
  end

  def test_one_function_one_block
    my_last = lambda { |x| x.last }

    f = F . fn { |x| x.first } . fn(&my_last)
    result = f.call([1, [2,3]])
    assert Fixnum === result, "#{result} is not a number"
    assert_equal 2, result
  end

  def test_one_function_one_method
    my_last = lambda { |x| x.last }

    f = F . first . fn(&my_last)
    result = f.call([1, [2,3]])
    assert Fixnum === result, "#{result} is not a number"
    assert_equal 2, result
  end

  def test_undefined_method
    f = F . foo
    assert_raises(NoMethodError) { f.call(1) }
  end

  def test_identity
    assert_equal 1, F.call(1)
  end

  def test_partially_applied_method
    f = F . split(":")
    result = f.call("localhost:9092")
    assert Array === result, "#{result} is not an array"
    assert_equal ["localhost", "9092"], result
  end

  def test_partially_applied_fn
    split = lambda { |x, *args| x.split(*args) }
    f = F . fn(":", &split)
    result = f.call("localhost:9092")
    assert Array === result, "#{result} is not an array"
    assert_equal ["localhost", "9092"], result
  end
end
