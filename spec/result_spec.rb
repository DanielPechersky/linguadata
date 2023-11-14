# frozen_string_literal: true

RSpec.describe Linguadata::Result do
  let(:success) { described_class::Success }
  let(:failure) { described_class::Failure }

  it "Result::Success and Result::Failure share the exact same methods" do
    expect(success.instance_methods).to match_array(failure.instance_methods)
  end

  it "returns value as option" do
    expect(success[1].success).to eq(Linguadata::Option::Some[1])
    expect(success[1].failure).to eq(Linguadata::Option::None[])

    expect(failure[1].success).to eq(Linguadata::Option::None[])
    expect(failure[1].failure).to eq(Linguadata::Option::Some[1])
  end

  it "returns value when necessary" do
    expect(success[1].value).to eq(1)
    expect(success[1].unwrap).to eq(1)
    expect { failure[1].value }.to raise_error(described_class::NoValueInFailureError)
    expect { failure[1].unwrap }.to raise_error(described_class::NoValueInFailureError)

    expect { success[1].error }.to raise_error(described_class::NoErrorInSuccessError)
    expect { success[1].unwrap_failure }.to raise_error(described_class::NoErrorInSuccessError)
    expect(failure[1].error).to eq(1)
    expect(failure[1].unwrap_failure).to eq(1)
  end

  it "success? and failure? methods work as expected" do
    expect(success[1].success?).to eq(true)
    expect(failure[1].success?).to eq(false)

    expect(success[1].failure?).to eq(false)
    expect(failure[1].failure?).to eq(true)
  end

  it "map methods work as expected" do
    expect(success[1].map { |x| x + 1 }).to eq(success[2])
    expect(failure[1].map { |x| x + 1 }).to eq(failure[1])
    expect(success[1].map_failure { |x| x + 1 }).to eq(success[1])
    expect(failure[1].map_failure { |x| x + 1 }).to eq(failure[2])

    expect { success[1].map }.to raise_error(Linguadata::RequiredBlockError)
    expect { failure[1].map }.to raise_error(Linguadata::RequiredBlockError)
    expect { success[1].map_failure }.to raise_error(Linguadata::RequiredBlockError)
    expect { failure[1].map_failure }.to raise_error(Linguadata::RequiredBlockError)
  end

  it "map_failure method works as expected" do
    expect(success[1].map_failure { |x| x + 1 }).to eq(success[1])
    expect(failure[1].map_failure { |x| x + 1 }).to eq(failure[2])

    expect { success[1].map_failure }.to raise_error(Linguadata::RequiredBlockError)
    expect { failure[1].map_failure }.to raise_error(Linguadata::RequiredBlockError)
  end

  it "and_then method works as expected" do
    expect(success[1].and_then { |x| success[x + 1] }).to eq(success[2])
    expect(failure[1].and_then { |x| success[x + 1] }).to eq(failure[1])
    expect(success[1].and_then { |x| failure[x + 1] }).to eq(failure[2])
    expect(failure[1].and_then { |x| failure[x + 1] }).to eq(failure[1])

    expect { success[1].and_then }.to raise_error(Linguadata::RequiredBlockError)
    expect { failure[1].and_then }.to raise_error(Linguadata::RequiredBlockError)
  end

  it "or_else method works as expected" do
    expect(success[1].or_else { |x| success[x + 1] }).to eq(success[1])
    expect(failure[1].or_else { |x| success[x + 1] }).to eq(success[2])
    expect(success[1].or_else { |x| failure[x + 1] }).to eq(success[1])
    expect(failure[1].or_else { |x| failure[x + 1] }).to eq(failure[2])

    expect { success[1].or_else }.to raise_error(Linguadata::RequiredBlockError)
    expect { failure[1].or_else }.to raise_error(Linguadata::RequiredBlockError)
  end

  it "NoErrorInSuccessError has a message" do
    expect(described_class::NoErrorInSuccessError.new.message).to eq("Attempted to access an error from 'Success', which represents a successful outcome without errors.")
  end

  it "NoValueInFailureError has a message" do
    expect(described_class::NoValueInFailureError.new.message).to eq("Attempted to access a value from 'Failure', which only contains an error.")
  end
end
