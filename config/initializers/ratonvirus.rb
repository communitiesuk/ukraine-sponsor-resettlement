# config/initializers/ratonvirus.rb
Ratonvirus.configure do |config|
  config.scanner = :eicar
  config.storage = :filepath
end
