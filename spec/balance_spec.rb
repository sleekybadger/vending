# frozen_string_literal: true

RSpec.describe Vending::Balance do
  let(:coin1) { build(:coin, label: "1") }
  let(:coin2) { build(:coin, label: "2") }
  let(:coin3) { build(:coin, label: "3") }

  let(:coins) { {} }

  describe ".init_filled" do
    describe ".init_filled" do
      subject(:coins) { described_class.init_filled.coins }

      it { is_expected.not_to be_empty }
    end
  end

  describe "#value" do
    subject(:result) { described_class.new(coins:).value }

    context "when balance has some coins" do
      let(:coins) { { coin1 => 5, coin2 => 3 } }

      it { is_expected.to eq(1100) }
    end

    context "when balance is empty" do
      it { is_expected.to eq(0) }
    end
  end

  describe "#add_coins!" do
    subject(:balance) { described_class.new(coins:).add_coins!(label:, count:) }

    context "when coin is supported" do
      let(:label) { "3" }
      let(:count) { 2 }

      it { expect(balance.coins).to eq({ coin3 => 2 }) }
    end

    context "when coin isn't supported" do
      let(:label) { "10" }
      let(:count) { 2 }

      its_block { is_expected.to raise_error(Vending::UnsupportedCoinLabel) }
    end
  end

  describe "#sum!" do
    subject(:balance) { first_balance.sum!(second_balance) }

    let(:first_balance) { described_class.new(coins: first_balance_coins) }
    let(:second_balance) { described_class.new(coins: second_balance_coins) }

    let(:first_balance_coins) { { coin1 => 5, coin2 => 3 } }
    let(:second_balance_coins) { { coin1 => 1, coin2 => 4 } }

    it { expect(balance.coins).to eq({ coin1 => 6, coin2 => 7 }) }
  end

  describe "#subtract!" do
    subject(:balance) { first_balance.subtract!(second_balance) }

    let(:first_balance) { described_class.new(coins: first_balance_coins) }
    let(:second_balance) { described_class.new(coins: second_balance_coins) }

    let(:first_balance_coins) { { coin1 => 5, coin2 => 3 } }
    let(:second_balance_coins) { { coin1 => 1, coin2 => 2 } }

    it { expect(balance.coins).to eq({ coin1 => 4, coin2 => 1 }) }
  end

  describe "#clear!" do
    subject(:balance) { described_class.new(coins:).clear! }

    let(:coins) { { coin1 => 5, coin2 => 3 } }

    it { expect(balance.coins).to eq({}) }
  end

  describe "#empty?" do
    subject(:result) { described_class.new(coins:).empty? }

    context "when balance has some coins" do
      let(:coins) { { coin1 => 5, coin2 => 3 } }

      it { is_expected.to be_falsey }
    end

    context "when balance is empty" do
      it { is_expected.to be_truthy }
    end
  end

  describe "#to_s" do
    subject(:result) { described_class.new(coins:).to_s }

    let(:coins) { { coin1 => 5, coin2 => 3 } }

    it { is_expected.to eq("1 * 5, 2 * 3") }
  end
end
