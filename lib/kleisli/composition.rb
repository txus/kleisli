require_relative 'blankslate'

class Proc
  def self.comp(f, g)
    lambda { |*args| f[g[*args]] }
  end

  def *(g)
    Proc.comp(self, g)
  end
end

module Kleisli
  class ComposedFn < BlankSlate
    def initialize(fns=[])
      @fns = fns
    end

    def method_missing(m, *args, &block)
      fn = -> a, x {
        if x.respond_to?(m)
          x.send(m, *a)
        else
          send(m, *a)
        end
      }.curry[args]
      ComposedFn.new(@fns + [fn])
    end

    def call(*args)
      @fns.reduce(:*).call(*args)
    end

    def to_ary
      @fns.to_ary
    end
  end
end

F = Kleisli::ComposedFn.new
