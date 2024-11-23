class Rack::Attack
  throttle('req/ip', limit: 5, period: 1.second) do |req|
    req.ip if req.path == '/catalogs/filters'
  end

  blocklist('block abusers') do |req|
    Rack::Attack::Fail2Ban.filter("abusive-#{req.ip}", maxretry: 10, findtime: 1.minute, bantime: 10.minutes) do
      req.path == '/catalogs/filters'
    end
  end

  safelist('localhost') do |req|
    req.ip == '127.0.0.1'
  end
end
