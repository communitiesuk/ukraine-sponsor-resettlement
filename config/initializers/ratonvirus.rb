# config/initializers/ratonvirus.rb
Ratonvirus.configure do |config|
  config.scanner = :eicar
  config.storage = :active_storage
end
