#!/usr/bin/env ruby

require 'test/unit'
require_relative 'test_helper'
require 'card_validator'

include Test::Unit

class CardTest < MiniTest::Unit::TestCase
  def setup
    @card = CardValidator.new
  end

  def test_visa_valid
    assert_equal "VISA: 4408041234567893 (valid)", @card.validate_card("4408041234567893")
    assert_equal "VISA: 4417123456789112 (invalid)", @card.validate_card("4417123456789112")

    assert_equal "VISA: 4111111111111111 (valid)", @card.validate_card("4111111111111111")
    assert_equal "VISA: 4111111111111 (invalid)", @card.validate_card("4111111111111")
    assert_equal "VISA: 4012888888881881 (valid)", @card.validate_card("4012888888881881")
  end

  def test_amex
    assert_equal "AMEX: 378282246310005 (valid)", @card.validate_card("378282246310005")
  end

  def test_discover
    assert_equal "Discover: 6011111111111117 (valid)", @card.validate_card("6011111111111117")
  end

  def test_mastercard
    assert_equal "MasterCard: 5105105105105100 (valid)", @card.validate_card("5105105105105100")
    assert_equal "MasterCard: 5105105105105106 (invalid)", @card.validate_card("5105105105105106")
    assert_equal "MasterCard: 5204105105105100 (valid)", @card.validate_card("5204105105105100")
    assert_equal "MasterCard: 5501105105105100 (valid)", @card.validate_card("5501105105105100")
  end

  def test_unknown_type
    assert_equal "Unknown: 5600105105105100 (invalid)", @card.validate_card("5600105105105100")
    assert_equal "Unknown: 9111111111111111 (invalid)", @card.validate_card("9111111111111111")
  end

  def test_alpha_number
    assert_equal true, @card.valid_card_number?("5105105105105100")
    assert_equal false, @card.valid_card_number?("510510510510510a"),
  end

  def test_empty
    assert_equal "Unknown:  (invalid)", @card.validate_card("")
  end

  def test_card_length
    assert_equal false, @card.valid_card_length?("VISA", "423456789012")
    assert_equal true, @card.valid_card_length?("VISA", "4234567890123")
    assert_equal true, @card.valid_card_length?("VISA", "4234567890123456")
    assert_equal false, @card.valid_card_length?("VISA", "some text")
    assert_equal false, @card.valid_card_length?("", "")
    assert_equal false, @card.valid_card_length?("", "4234567890123")
    assert_equal false, @card.valid_card_length?("AMEX", "4234567890123")
    assert_equal true, @card.valid_card_length?("AMEX", "378282246310005")
  end

  def test_number_validator
    assert_equal true, @card.valid_card_number?("000")
    assert_equal true, @card.valid_card_number?("123")
    assert_equal false, @card.valid_card_number?("")
    assert_equal true, @card.valid_card_number?("01010101010104")
    assert_equal false, @card.valid_card_number?("-123")
  end

end