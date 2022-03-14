require "sinatra"

get "/data" do
  "Hello world!"
end

post "/*" do
  logger.info "POST request received on #{request.path_info}"
  logger.info "Body: #{request.body.read}"
  logger.info "Headers: #{JSON.generate(request.env)}"
  return 204
end
