require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    @logger.info(log_request(env))
    @app.call(env, @logger)
  end

  def log_request(env)
    "Request:" + env['REQUEST_METHOD'] + env['PATH_INFO']
  end
end
