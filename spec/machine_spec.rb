# frozen_string_literal: true

RSpec.describe Vending::Machine do
  describe "#add_coin" do
    subject(:result) { described_class.new.add_coin(label:) }

    let(:label) { "0.5" }
    let(:coin) { build(:coin, label:) }

    it { expect(result.coins).to eq({ coin => 1 }) }
  end

  describe "#purchase" do
    subject(:result) { described_class.new(inventory:, machine_balance:, user_balance:).purchase(id: product_id) }

    let(:inventory) { Vending::Inventory.new(products:, quantities:) }
    let(:machine_balance) { Vending::Balance.new(coins: machine_coins) }
    let(:user_balance) { Vending::Balance.new(coins: user_coins) }

    let(:product_id) { 1 }
    let(:product) { build(:product, id: product_id, label: "Cola", price: 125) }
    let(:products) { { product_id => product } }

    let(:quantities) { {} }
    let(:machine_coins) { {} }
    let(:user_coins) { {} }

    context "when purchase successful" do
      let(:quantities) { { product_id => 1 } }
      let(:coin) { build(:coin, label: "0.25") }
      let(:user_coins) { { coin => 5 } }

      it "returns product and empty change" do
        product, change = result

        expect(product).to eq(product)
        expect(change.coins).to eq({})
      end

      its_block { is_expected.to(change { user_balance.coins }.from({ coin => 5 }).to({})) }
      its_block { is_expected.to(change { machine_balance.coins }.from({}).to({ coin => 5 })) }
      its_block { is_expected.to(change { inventory.quantities }.from({ 1 => 1 }).to({ 1 => 0 })) }

      context "when user inserted more coins than required" do
        let(:coin25) { build(:coin, label: "0.25") }
        let(:coin50) { build(:coin, label: "0.5") }

        context "when machine has coins to give a change" do
          let(:user_coins) { { coin50 => 4 } }
          let(:machine_coins) { { coin25 => 1 } }

          it "returns product and change" do
            product, change = result

            expect(product).to eq(product)
            expect(change.coins).to eq({ coin50 => 1, coin25 => 1 })
          end
        end

        context "when machine hasn't coins to give a change" do
          let(:user_coins) { { coin50 => 4 } }

          its_block { is_expected.to raise_error(Vending::NotEnoughCoinsForChange) }
        end
      end
    end

    context "when product is out of stock" do
      let(:quantities) { { product_id => 0 } }

      its_block { is_expected.to raise_error(Vending::ProductIsOutOfStock) }
    end

    context "when user hasn't enough coins" do
      let(:quantities) { { product_id => 1 } }

      its_block { is_expected.to raise_error(Vending::NotEnoughCoinsForPurchase) }
    end
  end
end
