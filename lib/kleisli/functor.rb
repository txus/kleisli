module Kleisli
  class Functor
    def fmap(_f = nil, &_block)
      raise NotImplementedError, "this functor doesn't implement fmap"
    end
  end
end
