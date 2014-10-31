require "kleisli/functor"

module Kleisli
  class Monad < Functor
    def >(block)
      raise NotImplementedError, "this monad doesn't implement >->"
    end

    def >>(block)
      self > block
    end
  end
end
