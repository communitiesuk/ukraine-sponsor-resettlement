host = ENV.fetch("CLAMD_HOST", "localhost")
port = ENV.fetch("CLAMD_PORT", "3310")
config_path = ENV.fetch("CLAMD_CONFIG_PATH", "config/clamd.conf")

config = %{
TCPAddr #{host}
TCPSocket #{port}
}

File.write(config_path, config)

Clamby.configure({
  daemonize: true,
  stream: true,
  error_file: config_path
})
