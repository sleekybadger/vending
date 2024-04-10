# frozen_string_literal: true

module Vending
  Product = Struct.new(:id, :label, :price, keyword_init: true)

  Coin = Struct.new(:label, keyword_init: true) do
    def value
      (label.to_f * 100).to_i
    end
  end
end
