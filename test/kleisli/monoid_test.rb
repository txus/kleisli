require 'test_helper'

class MonoidTest < MiniTest::Unit::TestCase
  def test_string_fold
    assert_equal "hellogoodbye", "hello".fold(%w(good bye))
  end

  def test_array_fold
    assert_equal [1, 2, 3], [1].fold([[2], [3]])
  end

  def test_hash_fold
    assert_equal({a: 1, b: 2, c: 3}, {a: 1}.fold([{b: 2}, {c: 3}]))
  end

  def test_fixnum_fold
    assert_equal 6, 1.fold([2,3])
  end

  def test_float_fold
    assert_equal 6.0, 1.0.fold([2.0,3.0])
  end
end
