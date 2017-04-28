require "kleisli/composition"
require "kleisli/maybe"
require "kleisli/either"
require "kleisli/try"
require "kleisli/future"

module Kleisli
  module Globals
    ### kleisli/composition ###
    F = Kleisli::ComposedFn.new

    ### kleisli/maybe ###
    Maybe = Kleisli::Maybe.method(:lift)
    def Maybe(v)
      Maybe.(v)
    end
    def None()
      Maybe(nil)
    end
    def Some(v)
      Maybe(v)
    end

    ### kleisli/either ###
    Right = Kleisli::Either::Right.method(:new)
    Left  = Kleisli::Either::Left.method(:new)
    def Right(v)
      Kleisli::Either::Right.new(v)
    end
    def Left(v)
      Kleisli::Either::Left.new(v)
    end

    ### kleisli/try ###
    def Try(&f)
      Kleisli::Try.lift(f)
    end

    ### kleisli/future ###
    def Future(v=nil, &block)
      Kleisli::Future.lift(v, &block)
    end
  end
end
