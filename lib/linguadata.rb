# frozen_string_literal: true

require_relative "linguadata/version"

module Linguadata
  class RequiredBlockError < ArgumentError
    def initialize(msg = "A block was required but not passed")
      super
    end
  end

  def self.validate_block_presence(block)
    raise RequiredBlockError if block.nil?
    block
  end

  module Option
    class Some < Data.define(:value)
      alias_method :unwrap, :value

      def map(&block)
        Some[Linguadata.validate_block_presence(block).call(value)]
      end

      def some? = true

      def none? = false

      def unwrap_or_else(&block)
        Linguadata.validate_block_presence(block)
        value
      end

      def unwrap_or(_other) = value

      def and_then(&block)
        Linguadata.validate_block_presence(block).call(value)
      end

      def filter(&block)
        if Linguadata.validate_block_presence(block).call(value)
          self
        else
          None[]
        end
      end
    end

    class None < Data.define
      def value = raise NoValueError

      alias_method :unwrap, :value

      def map(&block)
        Linguadata.validate_block_presence(block)
        self
      end

      def some? = false

      def none? = true

      def unwrap_or_else(&block)
        Linguadata.validate_block_presence(block).call
      end

      def unwrap_or(other) = other

      def and_then(&block)
        Linguadata.validate_block_presence(block)
        self
      end

      def filter(&block)
        Linguadata.validate_block_presence(block)
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

      def map(&block) = Success[block.call(value)]

      def map_failure(&_block) = self

      def and_then(&block) = block.call(value)

      def or_else(&_block) = self
    end

    class Failure < Data.define(:error)
      def value = raise NoValueInFailureError

      alias_method :unwrap, :value
      alias_method :unwrap_failure, :error

      def success? = false

      def failure? = true

      def success = Option::None[]

      def failure = Option::Some[error]

      def map(&_block) = self

      def map_failure(&block) = Failure[block.call(error)]

      def and_then(&_block) = self

      def or_else(&block) = block.call(error)
    end

    class NoErrorInSuccessError < StandardError
      def initialize(msg = "Attempted to access an error from 'Success', which represents a successful outcome without errors.")
        super
      end
    end

    class NoValueInFailureError < StandardError
      def initialize(msg = "Attempted to access a value from 'Failure', which only contains an error.")
        super
      end
    end
  end
end
