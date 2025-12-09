class Rack::Attack
  # Throttle requests to API endpoints by IP address
  throttle('api/ip', limit: 60, period: 1.minute) do |req|
    # Only throttle API paths
    if req.path.start_with?('/api')
      # Use real IP when behind proxies if configured properly
      req.ip
    end
  end

  # A slightly higher limit for authenticated users (by token)
  throttle('api/user', limit: 300, period: 5.minutes) do |req|
    next unless req.path.start_with?('/api')
    # Try to key by user id extracted from Authorization Bearer token
    auth = req.env['HTTP_AUTHORIZATION']
    if auth.present? && auth =~ /^Bearer (.+)$/i
      token = Regexp.last_match(1)
      begin
        payload = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
        "user:#{payload['user_id']}"
      rescue StandardError
        nil
      end
    end
  end

  # Return a 429 with a JSON body for throttled API requests
  self.throttled_response = lambda do |env|
    now = Time.now.utc
    retry_after = (env['rack.attack.match_data'] || {})[:period]
    headers = {
      'Content-Type' => 'application/json',
      'Retry-After' => retry_after.to_s
    }
    [429, headers, [{ error: 'Rate limit exceeded. Try again later.' }.to_json]]
  end
end
