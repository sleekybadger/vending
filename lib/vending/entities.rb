# frozen_string_literal: true

module Vending
  CENTS_PER_DOLLAR = 100

  Product = Struct.new(:id, :label, :price, keyword_init: true) do
    def human_price
      format("%.2f", price.to_f / CENTS_PER_DOLLAR)
    end
  end

  Coin = Struct.new(:label, keyword_init: true) do
    def value
      (label.to_f * CENTS_PER_DOLLAR).to_i
    end
  end
end
