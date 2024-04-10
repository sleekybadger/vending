# frozen_string_literal: true

module Vending
  module Factories
    LABEL_TO_FACTORY = {
      coin: Coin,
      product: Product,
    }.freeze

    def build(label, **data)
      LABEL_TO_FACTORY.fetch(label).new(**data)
    end
  end
end

RSpec.configure do |config|
  config.include Vending::Factories
end
