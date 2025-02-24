host = ENV.fetch("CLAMD_HOST", "localhost")
port = ENV.fetch("CLAMD_PORT", "3310")
config_path = ENV.fetch("CLAMD_CONFIG_PATH", "config/clamd.conf")

config = %(
TCPAddr #{host}
TCPSocket #{port}
StreamMinPort 1024
StreamMaxPort 2048
StreamMaxLength 20M
)

File.write(config_path, config)

Clamby.configure({
  daemonize: true,
  stream: true,
  config_file: config_path,
})
