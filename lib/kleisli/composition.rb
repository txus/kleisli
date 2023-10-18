module Kleisli
  class ComposedFn < BasicObject
    def self.comp(f, g)
      lambda { |*args| f[g[*args]] }
    end

    def initialize(fns=[])
      @fns = fns
    end

    def fn(*args, &block)
      f = -> arguments, receiver {
        block.call(receiver, *arguments)
      }.curry[args]
      ComposedFn.new(@fns + [f])
    end

    def method_missing(meth, *args, &block)
      f = -> arguments, receiver {
        receiver.send(meth, *arguments, &block)
      }.curry[args]
      ComposedFn.new(@fns + [f])
    end

    def call(*args)
      if @fns.any?
        @fns.reduce { |f, g| ComposedFn.comp(f, g) }.call(*args)
      else
        args.first
      end
    end

    def to_ary
      @fns.to_ary
    end
  end
end
