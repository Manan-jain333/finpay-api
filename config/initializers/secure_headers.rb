# Configure secure HTTP headers for the application.
# See https://github.com/twitter/secureheaders for details.
SecureHeaders::Configuration.default do |config|
  # Strict Transport Security - enforce HTTPS for 2 years and include subdomains.
  config.hsts = "max-age=#{2.years.to_i}; includeSubDomains"

  # Prevent clickjacking
  config.x_frame_options = 'DENY'

  # Prevent MIME type sniffing
  config.x_content_type_options = 'nosniff'

  # XSS protection (mostly legacy, but harmless)
  config.x_xss_protection = '1; mode=block'

  # Prevent leaking referrer for cross-origin requests
  config.referrer_policy = 'strict-origin-when-cross-origin'

  # Content Security Policy - conservative default that allows self and data/images
  config.csp = {
    default_src: %w('self'),
    script_src: %w('self' 'unsafe-inline' 'unsafe-eval' https:),
    style_src: %w('self' 'unsafe-inline' https:),
    img_src: %w('self' data: https:),
    font_src: %w('self' data: https:),
    connect_src: %w('self' https: ws: wss:),
    base_uri: %w('self'),
    form_action: %w('self')
  }

  # Note: older versions of secure_headers used `permissions_policy`, which
  # may not be available in all gem versions. To avoid initialization errors
  # we omit a permissions_policy here. Add a custom header if you need to set
  # Permissions-Policy / Permissions-Policy headers explicitly for your app.
end
