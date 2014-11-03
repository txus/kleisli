require 'kleisli/monad'

module Kleisli
  class Parser < Monad
    def self.lift(v)
      new(v)
    end

    def initialize(v=nil)
      @v = v
    end

    # def call(s)
    #   [@v, s]
    # end

    def >(block)
      -> s {
        result = call s
        unless result.nil?
          parsed, remaining = result
          block.call(parsed).call(remaining)
        end
      }
    end

    def mempty

    end

    def mappend(other)

    end

    module DSL
      def any_char
        AnyChar.new
      end
    end

    class AnyChar < Parser
      def call(s)
        unless s.empty?
          [s[0], s[1..-1]]
        end
      end
    end

    class Failure < Parser
      def call(s)
        nil
      end
    end

    class Choice < Parser
      def call(*parsers)
        -> s {
          parsers.map { |parser| parser.call(s) }.drop_while { |x| x.nil? }.first
        }
        nil
      end
    end

    class CharSatisfies < Parser
      def call(pred)
        AnyChar.new >-> c {
          if pred.call(c)
            Parser.lift(c)
          else
            mzero
          end
        }
      end

    end
  end
end

def Parser(v)
  Kleisli::Parser.lift(v)
end

include Kleisli::Parser::DSL

any_two_chars = any_char >-> a {
  any_char >-> b {
    Parser(a + b)
  }
}

puts any_two_chars.call("ab")
