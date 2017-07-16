require 'test_helper'

class EitherTest < Minitest::Test
  def test_lift_right
    assert_equal 3, Right(3).value
  end

  def test_lift_left
    assert_equal "error", Left("error").value
  end

  def test_bind_right
    v = Right(1) >-> x {
      if x == 1
        Right(x + 90)
      else
        Left("FAIL")
      end
    }
    assert_equal Right(91), v
  end

  def test_bind_left
    v = Left("error") >-> x {
      Right(x * 20)
    }
    assert_equal Left("error"), v
  end

  def test_fmap_right
    assert_equal Right(2), Right(1).fmap { |x| x * 2 }
  end

  def test_fmap_left
    assert_equal Left("error"), Left("error").fmap { |x| x * 2 }
  end

  def test_to_maybe_right
    assert_equal Some(2), Right(1).fmap { |x| x * 2 }.to_maybe
  end

  def test_to_maybe_left
    assert_equal None(), Left("error").fmap { |x| x * 2 }.to_maybe
  end

  def test_pointfree
    assert_equal Right(10), Right(5) >> F . fn(&Right) . *(2)
  end

  def test_applicative_functor_right_arity_1
    assert_equal Right(20), Right(-> x { x * 2 }) * Right(10)
  end

  def test_applicative_functor_right_arity_2
    assert_equal Right(20), Right(-> x, y { x * y }) * Right(10) * Right(2)
  end

  def test_applicative_functor_left
    assert_equal Left("error"), Right(-> x, y { x * y }) * Left("error") * Right(2)
  end

  def test_equality_with_other_type
    refute_equal nil, Right(nil)
  end
end
