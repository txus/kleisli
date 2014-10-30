require 'kleisli/monad'
require 'kleisli/maybe'

module Kleisli
  class Either < Monad
    attr_reader :right, :left

    def ==(other)
      right == other.right && left == other.left
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
    end
  end
end

def Right(v)
  Kleisli::Either::Right.new(v)
end

def Left(v)
  Kleisli::Either::Left.new(v)
end
