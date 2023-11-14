# frozen_string_literal: true

RSpec.describe Linguadata do
  it "has a version number" do
    expect(Linguadata::VERSION).not_to be nil
  end

  it "RequiredBlockError has a message" do
    expect(described_class::RequiredBlockError.new.message).to eq("A block was required but not passed")
  end
end
