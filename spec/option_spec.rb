# typed: false
# frozen_string_literal: true

RSpec.describe Linguadata::Option do
  it "Option::Some and Option::None share the exact same methods" do
    expect(described_class::Some.instance_methods).to match_array(described_class::None.instance_methods)
  end

  it "Option::Some and Option::None share the exact same class methods" do
    expect(described_class::Some.methods).to match_array(described_class::None.methods)
  end
end
