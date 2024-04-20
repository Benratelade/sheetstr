MoneyRails.configure do |config|
  # set the default currency
  config.default_currency = :aud
  config.locale_backend = nil
  config.rounding_mode = BigDecimal::ROUND_HALF_UP

  config.default_format = {
    sign_before_symbol: nil,
    symbol: nil,
    symbol_before_without_space: true,
    thousands_separator: ","
  }
end