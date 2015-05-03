module Workflows
  class ErrorValue < Struct.new(:value)
  end

  module Error
    extend self

    def error?(e)
      ErrorValue === e
    end

    def success?(e)
      ! error?(e)
    end

    def to_error(e)
      case e
      when ErrorValue
        e
      else
        ErrorValue.new(e)
      end
    end

    def compose_with_error_handling(*fns)
      fns.flatten.inject do |composed, fn|
        -> {
          last_return = composed.call
          if error?(last_return)
            last_return
          else
            fn.call
          end
        }
      end
    end
  end
end
