lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Lita.configure do |config|
  config.robot.name = 'litany'
  config.robot.alias = 'ss'

  config.robot.log_level = :info

  config.robot.adapter = :shell
  config.adapters.slack.token = "xoxb-31097453729-k8Xil8d4cGcwL0ulxdJMhWjd"

  config.redis[:host] = "redis"
end

Dir['lib/lita/handlers/*.rb'].each do |handler|
  require "lita/handlers/#{File.basename(handler, '.rb')}"
end
