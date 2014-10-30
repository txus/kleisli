module Kleisli
  class Functor
    def fmap(&f)
      raise NotImplementedError, "this functor doesn't implement fmap"
    end
  end
end
