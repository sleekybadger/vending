# frozen_string_literal: true

require "tty-prompt"

module Vending
  class CLI
    MENUS = [
      MAIN_MENU = :main_menu,
      ADD_COIN_MENU = :add_coin_menu,
      PURCHASE_MENU = :purchase_menu,
    ].freeze

    PER_PAGE = 10
    EXIT_SIGNAL = :exit
    CLEAR_ESC_SEQ = "\e[2J\e[f"

    def initialize(debug: false)
      @debug = debug

      render_screen(MAIN_MENU)
    end

    def main_menu
      label = render_menu("Vending Machine") do |menu|
        menu.choice "Add Coin", ADD_COIN_MENU
        menu.choice "Purchase", PURCHASE_MENU
        menu.choice "Exit", EXIT_SIGNAL
      end

      render_screen(label)
    end

    def add_coin_menu
      coin_label = render_menu("Add Coin") do |menu|
        Balance::SUPPORTED_COIN_LABELS.each do |label|
          menu.choice label, label
        end

        menu.choice "Back", MAIN_MENU
      end

      machine.add_coin!(label: coin_label)

      render_message { |tty| tty.ok("Your #{coin_label} coin was successfully added.") }
      render_screen(ADD_COIN_MENU)
    end

    def purchase_menu # rubocop:disable Metrics/AbcSize
      product_id = render_menu("Purchase") do |menu|
        machine.products.each do |product|
          menu.choice "#{product.label} #{product.human_price}", product.id
        end

        menu.choice "Back", MAIN_MENU
      end

      product, change = machine.purchase!(id: product_id)

      message = [
        "Please take your cool bottle of #{product.label}.",
        ("And don't forget your change, sir: #{change}." unless change.empty?),
      ].compact.join("\n")

      render_message(timeout: 2.5) { |tty| tty.ok(message) }
      render_screen(MAIN_MENU)
    rescue ProductIsOutOfStock
      render_message { |prompt| prompt.error("Sorry, product is out of stock, please try another one.") }
      render_screen(PURCHASE_MENU)
    rescue NotEnoughCoinsForPurchase
      render_message { |prompt| prompt.error("Please add more coins or try another one.") }
      render_screen(PURCHASE_MENU)
    rescue NotEnoughCoinsForChange
      render_message { |prompt| prompt.error("Sorry, no coins for the change, please try another one.") }
      render_screen(PURCHASE_MENU)
    end

    private

    attr_reader :debug

    def machine
      @machine ||= Machine.new
    end

    def render_menu(label, &block)
      prompt.select(label, per_page: PER_PAGE, &block).tap do |value|
        return render_screen(value) if MENUS.include?(value)

        exit if value == EXIT_SIGNAL
      end
    end

    def render_message(timeout: 1.5)
      yield prompt

      sleep(timeout)
    end

    def render_screen(label)
      clear_screen

      if debug
        pp machine
        puts
      end

      send(label)
    end

    def clear_screen
      print CLEAR_ESC_SEQ
    end

    def prompt
      @prompt ||= ::TTY::Prompt.new(quiet: true)
    end
  end
end
