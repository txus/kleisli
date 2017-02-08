require 'kleisli/monad'
require 'kleisli/maybe'

module Kleisli
  class Either < Monad
    attr_reader :right, :left

    def ==(other)
      right == other.right && left == other.left
    end

    def *(other)
      self >-> f {
        other >-> val {
          Right(f.arity > 1 ? f.curry.call(val) : f.call(val))
        }
      }
    end

    class Right < Either
      alias value right

      def initialize(right)
        @right = right
      end

      def >(f)
        f.call(@right)
      end

      def fmap(&f)
        Right.new(f.call(@right))
      end

      def to_maybe
        Maybe::Some.new(@right)
      end

      def or(other=nil, &other_blk)
        self
      end

      def to_s
        "Right(#{@right.inspect})"
      end
      alias inspect to_s

      def success?
        true
      end

      def failure?
        false
      end
    end

    class Left < Either
      alias value left

      def initialize(left)
        @left = left
      end

      def >(f)
        self
      end

      def fmap(&f)
        self
      end

      def to_maybe
        Maybe::None.new
      end

      def or(other=self, &other_blk)
        if other_blk
          other_blk.call(@left)
        else
          other
        end
      end

      def to_s
        "Left(#{@left.inspect})"
      end
      alias inspect to_s

      def success?
        false
      end

      def failure?
        true
      end
    end
  end
end

Right = Kleisli::Either::Right.method(:new)
Left = Kleisli::Either::Left.method(:new)

def Right(v)
  Kleisli::Either::Right.new(v)
end

def Left(v)
  Kleisli::Either::Left.new(v)
end
