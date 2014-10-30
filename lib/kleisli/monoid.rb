module Kleisli
  module Monoid
    def fold(others)
      others.reduce(self) { |acc, x| acc.mappend x }
    end

    def mempty
      raise NotImplementedError, "this monoid doesn't implement mpemty"
    end

    def mappend(other)
      raise NotImplementedError, "this monoid doesn't implement mappend"
    end
  end
end

String.class_eval do
  include Kleisli::Monoid

  def mempty
    ""
  end

  alias mappend +
end

Array.class_eval do
  include Kleisli::Monoid

  def mempty
    []
  end

  alias mappend +
end

Hash.class_eval do
  include Kleisli::Monoid

  def mempty
    {}
  end

  alias mappend merge
end

Fixnum.class_eval do
  include Kleisli::Monoid

  def mempty
    0
  end

  alias mappend +
end

Float.class_eval do
  include Kleisli::Monoid

  def mempty
    0
  end

  alias mappend +
end
