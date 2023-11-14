# frozen_string_literal: true

require_relative "linguadata/version"

module Linguadata
  module Option
    class Some < Data.define(:value)
      alias_method :unwrap, :value

      def some? = true

      def none? = false

      def unwrap_or(_other) = value

      def unwrap_or_else(&block)
        raise RequiredBlockError if block.nil?
        value
      end

      def map(&block)
        raise RequiredBlockError if block.nil?
        Some[block.call(value)]
      end

      def and_then(&block)
        raise RequiredBlockError if block.nil?
        block.call(value)
      end

      def filter(&block)
        raise RequiredBlockError if block.nil?
        if block.call(value)
          self
        else
          None[]
        end
      end
    end

    class None < Data.define
      def value = raise NoValueError

      alias_method :unwrap, :value

      def some? = false

      def none? = true

      def unwrap_or(other) = other

      def unwrap_or_else(&block)
        raise RequiredBlockError if block.nil?
        block.call
      end

      def map(&block)
        raise RequiredBlockError if block.nil?
        self
      end

      def and_then(&block)
        raise RequiredBlockError if block.nil?
        self
      end

      def filter(&block)
        raise RequiredBlockError if block.nil?
        self
      end
    end

    def self.from_nillable(value)
      case value
      in nil
        None[]
      else
        Some[value]
      end
    end

    class NoValueError < StandardError
      def initialize(_msg = "Attempted to access a value from 'None', which does not hold any value.")
        super
      end
    end
  end

  module Result
    class Success < Data.define(:value)
      def error = raise NoErrorInSuccessError

      alias_method :unwrap, :value
      alias_method :unwrap_failure, :error

      def success? = true

      def failure? = false

      def success = Option::Some[value]

      def failure = Option::None[]

      def map(&block)
        raise RequiredBlockError if block.nil?
        Success[block.call(value)]
      end

      def map_failure(&block)
        raise RequiredBlockError if block.nil?
        self
      end

      def and_then(&block)
        raise RequiredBlockError if block.nil?
        block.call(value)
      end

      def or_else(&block)
        raise RequiredBlockError if block.nil?
        self
      end
    end

    class Failure < Data.define(:error)
      def value = raise NoValueInFailureError

      alias_method :unwrap, :value
      alias_method :unwrap_failure, :error

      def success? = false

      def failure? = true

      def success = Option::None[]

      def failure = Option::Some[error]

      def map(&block)
        raise RequiredBlockError if block.nil?
        self
      end

      def map_failure(&block)
        raise RequiredBlockError if block.nil?
        Failure[block.call(error)]
      end

      def and_then(&block)
        raise RequiredBlockError if block.nil?
        self
      end

      def or_else(&block)
        raise RequiredBlockError if block.nil?
        block.call(error)
      end
    end

    class NoErrorInSuccessError < StandardError
      def initialize(_msg = "Attempted to access an error from 'Success', which represents a successful outcome without errors.")
        super
      end
    end

    class NoValueInFailureError < StandardError
      def initialize(_msg = "Attempted to access a value from 'Failure', which only contains an error.")
        super
      end
    end
  end

  class RequiredBlockError < ArgumentError
    def initialize(_msg = "A block was required but not passed")
      super
    end
  end
end
