# typed: false
# frozen_string_literal: true

RSpec.describe Linguadata::Option do
  it "Option::Some and Option::None share the exact same methods" do
    expect(described_class::Some.instance_methods).to match_array(described_class::None.instance_methods)
  end

  it "Option::Some and Option::None share the exact same class methods" do
    expect(described_class::Some.methods).to match_array(described_class::None.methods)
  end

  it "map methods work as expected" do
    expect(described_class::Some[1].map { |x| x + 1 }).to eq(described_class::Some[2])
    expect(described_class::None[].map { |x| x + 1 }).to eq(described_class::None[])
  end
end
