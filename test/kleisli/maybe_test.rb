require 'test_helper'

class MaybeTest < MiniTest::Unit::TestCase
  def test_unwrapping_some
    assert_equal 3, Some(3).value
  end

  def test_unwrapping_none
    assert_equal nil, None().value
  end

  # def test_bind_none
  #   assert_equal None(), None() >> F . Maybe . *(2)
  # end

  # def test_bind_some
  #   assert_equal Some(6), Some(3) >> F . Maybe . *(2)
  # end

  def test_fmap_none
    assert_equal None(), None().fmap { |x| x * 2 }
  end

  def test_fmap_some
    assert_equal Some(6), Some(3).fmap { |x| x * 2 }
  end
end
