require 'kleisli/monad'
require 'kleisli/maybe'

module Kleisli
  class Try < Monad
    attr_reader :exception, :value

    def self.lift(f)
      Success.new(f.call)
    rescue => e
      Failure.new(e)
    end

    class Success < Try
      def initialize(value)
        @value = value
      end

      def >(f)
        f.call(@value)
      rescue => e
        Failure.new(e)
      end

      def fmap(f = nil, &block)
        Try { (f || block).call(@value) }
      end

      def to_maybe
        Maybe::Some.new(@value)
      end

      def to_either
        Either::Right.new(@value)
      end
    end

    class Failure < Try
      def initialize(exception)
        @exception = exception
      end

      def >(f)
        self
      end

      def fmap(_f = nil)
        self
      end

      def to_maybe
        Maybe::None.new
      end

      def to_either
        Either::Left.new(@exception)
      end
    end
  end
end

def Try(&f)
  Kleisli::Try.lift(f)
end
