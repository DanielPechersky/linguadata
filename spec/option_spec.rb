# frozen_string_literal: true

RSpec.describe Linguadata::Option do
  it "Option::Some and Option::None share the exact same methods" do
    expect(described_class::Some.instance_methods).to match_array(described_class::None.instance_methods)
  end

  it "returns value when necessary" do
    expect(described_class::Some[1].value).to eq(1)
    expect(described_class::Some[1].unwrap).to eq(1)
    expect { described_class::None[].value }.to raise_error(Linguadata::Option::NoValueError)
    expect { described_class::None[].unwrap }.to raise_error(Linguadata::Option::NoValueError)
  end

  it "map methods work as expected" do
    expect(described_class::Some[1].map { |x| x + 1 }).to eq(described_class::Some[2])
    expect(described_class::None[].map { |x| x + 1 }).to eq(described_class::None[])
  end

  it "some? and none? methods work as expected" do
    expect(described_class::Some[1].some?).to eq(true)
    expect(described_class::None[].some?).to eq(false)

    expect(described_class::Some[1].none?).to eq(false)
    expect(described_class::None[].none?).to eq(true)
  end

  it "unwrap_or_else and unwrap_or methods work as expected" do
    expect(described_class::Some[1].unwrap_or_else { 2 }).to eq(1)
    expect(described_class::None[].unwrap_or_else { 2 }).to eq(2)

    expect(described_class::Some[1].unwrap_or(2)).to eq(1)
    expect(described_class::None[].unwrap_or(2)).to eq(2)
  end

  it "and_then method works as expected" do
    expect(described_class::Some[1].and_then { |x| described_class::Some[x + 1] }).to eq(described_class::Some[2])
    expect(described_class::None[].and_then { |x| described_class::Some[x + 1] }).to eq(described_class::None[])
    expect(described_class::Some[1].and_then { |x| described_class::None[] }).to eq(described_class::None[])
  end

  describe "#from_nillable" do
    it "correctly converts nil to None" do
      expect(described_class.from_nillable(nil)).to eq(described_class::None[])
    end

    it "converts any other value to Some" do
      expect(described_class.from_nillable(1)).to eq(described_class::Some[1])
    end
  end
end
