# frozen_string_literal: true

RSpec.describe Linguadata::Option do
  let(:some) { described_class::Some }
  let(:none) { described_class::None }

  it "Option::Some and Option::None share the exact same methods" do
    expect(some.instance_methods).to match_array(none.instance_methods)
  end

  it "returns value when necessary" do
    expect(some[1].value).to eq(1)
    expect(some[1].unwrap).to eq(1)
    expect { none[].value }.to raise_error(described_class::NoValueError)
    expect { none[].unwrap }.to raise_error(described_class::NoValueError)
  end

  it "map methods work as expected" do
    expect(some[1].map { |x| x + 1 }).to eq(some[2])
    expect(none[].map { |x| x + 1 }).to eq(none[])
  end

  it "some? and none? methods work as expected" do
    expect(some[1].some?).to eq(true)
    expect(none[].some?).to eq(false)

    expect(some[1].none?).to eq(false)
    expect(none[].none?).to eq(true)
  end

  it "unwrap_or_else and unwrap_or methods work as expected" do
    expect(some[1].unwrap_or_else { 2 }).to eq(1)
    expect(none[].unwrap_or_else { 2 }).to eq(2)

    expect(some[1].unwrap_or(2)).to eq(1)
    expect(none[].unwrap_or(2)).to eq(2)

    expect { some[1].unwrap_or_else }.to raise_error(Linguadata::RequiredBlockError)
    expect { none[].unwrap_or_else }.to raise_error(Linguadata::RequiredBlockError)
  end

  it "and_then method works as expected" do
    expect(some[1].and_then { |x| some[x + 1] }).to eq(some[2])
    expect(none[].and_then { |x| some[x + 1] }).to eq(none[])
    expect(some[1].and_then { |_| none[] }).to eq(none[])

    expect { some[1].and_then }.to raise_error(Linguadata::RequiredBlockError)
    expect { none[].and_then }.to raise_error(Linguadata::RequiredBlockError)
  end

  it "filter method works as expected" do
    expect(some[1].filter { |x| x > 0 }).to eq(some[1])
    expect(some[1].filter { |x| x < 0 }).to eq(none[])
    expect(none[].filter { |x| x > 0 }).to eq(none[])
  end

  it "the error has a message" do
    expect(described_class::NoValueError.new.message).to eq("Attempted to access a value from 'None', which does not hold any value.")
  end

  describe "#from_nillable" do
    it "correctly converts nil to None" do
      expect(described_class.from_nillable(nil)).to eq(none[])
    end

    it "converts any other value to Some" do
      expect(described_class.from_nillable(1)).to eq(some[1])
    end
  end
end
