# frozen_string_literal: true

RSpec.describe Vending::Inventory do
  let(:products) { {} }
  let(:quantities) { {} }

  let(:id) { 1 }
  let(:product) { build(:product, id:) }

  describe ".init_filled" do
    subject(:result) { described_class.init_filled }

    it { expect(result.send(:products)).not_to be_empty }
    it { expect(result.send(:quantities)).not_to be_empty }
  end

  describe "#list" do
    subject(:result) { described_class.new(products:, quantities:).list }

    let(:products) { { id => product } }

    it { is_expected.to eq([product]) }
  end

  describe "#find!" do
    subject(:result) { described_class.new(products:, quantities:).find!(id:) }

    context "when product is present in inventory" do
      let(:products) { { id => product } }

      it { is_expected.to eq(product) }
    end

    context "when product is missing in inventory" do
      its_block { is_expected.to raise_error(Vending::ProductNotFound) }
    end
  end

  describe "#in_stock?" do
    subject(:result) { described_class.new(products:, quantities:).in_stock?(product:) }

    context "when product is present in inventory" do
      context "when product quantity greater than zero" do
        let(:quantities) { { id => 1 } }

        it { is_expected.to be_truthy }
      end

      context "when product quantity is zero" do
        let(:quantities) { { id => 0 } }

        it { is_expected.to be_falsey }
      end
    end

    context "when product is missing in inventory" do
      its_block { is_expected.to raise_error(Vending::UnsupportedProduct) }
    end
  end

  describe "#take_out!" do
    subject(:result) { described_class.new(products:, quantities:).take_out!(product:) }

    context "when product is present in inventory" do
      let(:quantities) { { id => 5 } }

      it { is_expected.to eq(4) }
    end

    context "when product is missing in inventory" do
      its_block { is_expected.to raise_error(Vending::UnsupportedProduct) }
    end
  end
end
