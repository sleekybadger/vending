# frozen_string_literal: true

RSpec.describe Vending::Coin do
  subject(:coin) { described_class.new(label:) }

  describe "#value" do
    subject(:result) { coin.value }

    context "when label contains float value" do
      let(:label) { "0.25" }

      it { is_expected.to eq(25) }
    end

    context "when label contains integer value" do
      let(:label) { "3" }

      it { is_expected.to eq(300) }
    end
  end
end

RSpec.describe Vending::Product do
  describe "#human_price" do
    subject(:result) { build(:product, price: 575).human_price }

    it { is_expected.to eq("5.75") }
  end
end
