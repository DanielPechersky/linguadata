# typed: strict
# frozen_string_literal: true

require_relative "linguadata/version"

module Linguadata
  class Error < StandardError; end

  module Option
    class Some < Data.define(:value)
      def unwrap = value

      def map(&block) = Some[block.call(value)]

      def some? = true

      def none? = false

      def unwrap_or_else(&_block) = value

      def unwrap_or(_other) = value
    end

    class None < Data.define
      def value = raise "Cannot get value from None"

      def unwrap = value

      def map(&_block) = self

      def some? = false

      def none? = true

      def unwrap_or_else(&block) = block.call

      def unwrap_or(other) = other
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
    class Success < Data.define(:value)
      def error = raise "Cannot get error from Success"

      def unwrap = value

      def unwrap_failure = error

      def success = Some[value]

      def failure = None[]

      def map(&block) = Success[block.call(value)]

      def map_failure(&_block) = self
    end

    class Failure < Data.define(:error)
      def value = raise "Cannot get value from Failure"

      def unwrap = value

      def unwrap_failure = error

      def success = None[]

      def failure = Some[error]

      def map(&_block) = self

      def map_failure(&block) = Failure[block.call(error)]
    end
  end
end
