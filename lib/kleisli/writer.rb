require 'kleisli/monad'
require 'kleisli/monoid'

module Kleisli
  class Writer < Monad
    def self.lift(log, value)
      new(log, value)
    end

    def initialize(log, value)
      @log, @value = log, value
    end

    def ==(other)
      unwrap == other.unwrap
    end

    def >(f)
      other_log, other_value = f.call(@value).unwrap
      Writer.new(@log + other_log, other_value)
    end

    def fmap(&f)
      new_value = f.call(@value)
      Writer.new(@log, new_value)
    end

    def unwrap
      [@log, @value]
    end
  end
end

def Writer(log, value)
  Kleisli::Writer.lift(log, value)
end
