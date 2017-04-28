require 'kleisli/monad'

module Kleisli
  class Future < Monad
    def self.lift(v=nil, &block)
      if block
        new(Thread.new(&block))
      else
        new(Thread.new { v })
      end
    end

    def initialize(t)
      @t = t
    end

    def >(f)
      f.call(-> { await })
    end

    def fmap(&f)
      Future.lift(f.call(-> { await }))
    end

    def await
      @t.join.value
    end
  end
end
