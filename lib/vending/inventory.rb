# frozen_string_literal: true

module Vending
  class Inventory
    PRODUCTS_DATA = [
      { label: "Cola", price: 575 },
      { label: "Fanta", price: 775 },
      { label: "Sprite", price: 925 },
      { label: "Pepsi", price: 450 },
    ].freeze

    class << self
      def init_filled
        data = PRODUCTS_DATA.each_with_object({ products: {}, quantities: {} }).with_index(1) do |(product, accum), id|
          accum[:products][id] = Product.new(id:, **product)
          accum[:quantities][id] = (PRODUCTS_DATA.count / 2) + id
        end

        new(**data)
      end
    end

    attr_reader :products, :quantities

    def initialize(products: {}, quantities: {})
      @products = products
      @quantities = quantities
    end

    def list
      products.values
    end

    def find!(id:)
      products[id] || raise(ProductNotFound)
    end

    def in_stock?(product:)
      raise UnsupportedProduct unless quantities.key?(product.id)

      quantities[product.id].positive?
    end

    def take_out!(product:)
      raise UnsupportedProduct unless quantities.key?(product.id)

      quantities[product.id] -= 1
    end
  end
end
