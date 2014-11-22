require 'test_helper'

class TryTest < MiniTest::Unit::TestCase
  def test_success
    assert_equal 2, Try { 10 / 5 }.value
  end

  def test_failure
    assert_kind_of ZeroDivisionError, Try { 10 / 0 }.exception
  end

  def test_to_maybe_success
    assert_equal Some(2), Try { 10 / 5 }.to_maybe
  end

  def test_to_maybe_failure
    assert_equal None(), Try { 10 / 0 }.to_maybe
  end

  def test_fmap_success
    assert_equal 4, Try { 10 / 5 }.fmap { |x| x * 2 }.value
  end

  def test_fmap_failure
    assert_kind_of ZeroDivisionError, Try { 10 / 0 }.fmap { |x| x * 2 }.exception
  end

  def test_bind
    try = Try { 20 / 10 } >-> number { Try { 10 / number } }
    assert_equal 5, try.value
  end
end
