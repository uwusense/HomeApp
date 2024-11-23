class Rack::Attack
  throttle('req/ip', limit: 5, period: 1.second) do |req|
    req.ip if req.path == '/catalogs/filters'
  end

  safelist('localhost') do |req|
    req.ip == '127.0.0.1'
  end
end
