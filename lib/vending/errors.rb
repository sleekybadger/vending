# frozen_string_literal: true

module Vending
  class Error < StandardError; end

  class UnsupportedCoinLabel < Error; end

  class UnsupportedProduct < Error; end

  class ProductNotFound < Error; end

  class ProductIsOutOfStock < Error; end

  class NotEnoughCoinsForPurchase < Error; end

  class NotEnoughCoinsForChange < Error; end
end
