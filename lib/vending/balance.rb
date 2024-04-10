# frozen_string_literal: true

module Vending
  class Balance
    SUPPORTED_COIN_LABELS = %w[0.25 0.5 1 2 3 5].freeze

    class << self
      def init_filled
        coins = SUPPORTED_COIN_LABELS.each_with_object({}).with_index do |(label, accum), index|
          coin = Coin.new(label:)
          count = SUPPORTED_COIN_LABELS.size - index

          accum[coin] = count
        end

        new(coins:)
      end
    end

    attr_reader :coins

    def initialize(coins: {})
      @coins = coins
    end

    def value
      coins.inject(0) do |accum, (coin, quantity)|
        coin.value * quantity + accum
      end
    end

    def add_coins!(label:, count: 1)
      raise UnsupportedCoinLabel unless SUPPORTED_COIN_LABELS.include?(label)

      coin = Coin.new(label:)

      coins[coin] ||= 0
      coins[coin] += count

      self
    end

    def sum!(other_balance)
      @coins = coins.merge(other_balance.coins) do |_, current_count, other_count|
        current_count + other_count
      end

      self
    end

    def sum(other_balance)
      dup.sum!(other_balance)
    end

    def subtract!(other_balance)
      @coins = coins.merge(other_balance.coins) do |_, current_count, other_count|
        current_count - other_count
      end

      self
    end

    def clear!
      @coins = {}

      self
    end
  end
end
