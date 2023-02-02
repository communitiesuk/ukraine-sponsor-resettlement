# rubocop:disable Lint/PercentStringArray Style/PercentLiteralDelimiters

SecureHeaders::Configuration.default do |config|
  config.cookies = {
    secure: true, # mark all cookies as "Secure"
    httponly: true, # mark all cookies as "HttpOnly"
  }
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.csp = {
    default_src: Rails.env.production? ? %w[https: 'self'] : %w[http: 'self' 'unsafe-inline'],
    connect_src: %w[
      'self'
    ],
    font_src: %w[
      'self'
    ],
    img_src: %w[
      'self'
    ],
    script_src: %w[
      'self'
      'unsafe-inline'
    ],
  }
end

# rubocop:enable  Lint/PercentStringArray Style/PercentLiteralDelimiters
