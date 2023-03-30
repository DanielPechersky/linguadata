# typed: strict
# frozen_string_literal: true

require_relative "linguadata/version"

module Linguadata
  class Error < StandardError; end

  module Option
    Some = Data.define(:value) do
      def unwrap
        value
      end

      def map(&block)
        Some[block.call(value)]
      end

      def some?
        true
      end

      def none?
        !some?
      end

      def unwrap_or_else(&_block)
        value
      end

      def unwrap_or(_other)
        value
      end
    end

    None = Data.define do
      def value
        raise "Cannot get value from None"
      end

      def unwrap
        value
      end

      def map(&_block)
        self
      end

      def some?
        false
      end

      def none?
        !some?
      end

      def unwrap_or_else(&block)
        block.call
      end

      def unwrap_or(other)
        other
      end
    end

    def from_nillable(value)
      if value.nil?
        None[]
      else
        Some[value]
      end
    end
  end

  module Result
    Success = Data.define(:value) do
      def error
        raise "Cannot get error from Success"
      end

      def unwrap
        value
      end

      def unwrap_failure
        error
      end

      def success
        Option::Some[value]
      end

      def failure
        Option::None[]
      end

      def map(&block)
        Success[block.call(value)]
      end

      def map_failure(&block)
        self
      end
    end

    Failure = Data.define(:error) do
      def value
        raise "Cannot get value from Failure"
      end

      def unwrap
        value
      end

      def unwrap_failure
        error
      end

      def success
        None[]
      end

      def failure
        Option[error]
      end

      def map(&block)
        self
      end

      def map_failure(&block)
        Failure[block.call(error)]
      end
    end
  end
end
