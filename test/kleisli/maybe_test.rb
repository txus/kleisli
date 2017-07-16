require 'test_helper'

class MaybeTest < Minitest::Test
  def test_unwrapping_some
    assert_equal 3, Some(3).value
  end

  def test_unwrapping_none
    assert_equal nil, None().value
  end

  def test_bind_none
    assert_equal None(), None() >> F . fn(&Maybe) . *(2)
  end

  def test_bind_some
    assert_equal Some(6), Some(3) >> F . fn(&Maybe) . *(2)
  end

  def test_fmap_none
    assert_equal None(), None().fmap { |x| x * 2 }
  end

  def test_fmap_some
    assert_equal Some(6), Some(3).fmap { |x| x * 2 }
  end

  def test_applicative_functor_some_arity_1
    assert_equal Some(20), Maybe(-> x { x * 2 }) * Maybe(10)
  end

  def test_applicative_functor_some_arity_2
    assert_equal Some(20), Maybe(-> x, y { x * y }) * Maybe(10) * Maybe(2)
  end

  def test_applicative_functor_none
    assert_equal None(), Maybe(-> x, y { x * y }) * None() * Maybe(2)
  end

  def test_equality_with_other_type
    refute_equal nil, None()
  end
end
