# frozen_string_literal: true

module Vending
  class Machine
    def initialize(inventory: Inventory.init_filled, machine_balance: Balance.init_filled, user_balance: Balance.new)
      @inventory = inventory
      @machine_balance = machine_balance
      @user_balance = user_balance
    end

    def products
      inventory.list
    end

    def add_coin!(label:)
      user_balance.add_coins!(label:)
    end

    def purchase!(id:)
      product = inventory.find!(id:)

      raise ProductIsOutOfStock unless inventory.in_stock?(product:)
      raise NotEnoughCoinsForPurchase if product.price > user_balance.value

      change = calculate_change(product)

      # Sum machine balance with user balance and subtract change
      machine_balance.sum!(user_balance).subtract!(change)

      # Reset user balance
      user_balance.clear!

      # Decrement product quantity
      inventory.take_out!(product:)

      [product, change]
    end

    private

    attr_reader :inventory, :user_balance, :machine_balance

    def calculate_change(product) # rubocop:disable Metrics/AbcSize
      change = Balance.new
      return change if user_balance.value == product.price

      coins_for_change.inject(user_balance.value - product.price) do |remaining, (coin, available_coins_count)|
        break remaining if remaining.zero?

        required_coins_count = remaining / coin.value
        used_coins_count = [required_coins_count, available_coins_count].min
        next remaining if used_coins_count.zero?

        change.add_coins!(label: coin.label, count: used_coins_count)

        remaining - (used_coins_count * coin.value)
      end.tap { |remaining| raise NotEnoughCoinsForChange if remaining.positive? }

      change
    end

    # Used sum of machine and user balance cause coins added
    # by user should also be available for a change
    def coins_for_change
      machine_balance
        .sum(user_balance)
        .coins
        .to_a
        .sort_by { |(coin, *)| -coin.value }
    end
  end
end
