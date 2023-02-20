require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env, logger)
      @logger = logger
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      make_params(env)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      logger_info
      @response.finish
    end

    private

    def make_params(env)
      path = env['REQUEST_PATH'].split('/')
      @request.params[:id] = path[2].to_i
      @logger.info("Parameters: " + @request.params.to_s)
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def status(status)
      @response.status = status
    end

    def headers
      @response
    end

    def logger_info
      @logger.info(
        "Response:" + @response.status.to_s +
        @response['Content-Type'].to_s +
        @request.env['simpler.template_path'].to_s
      )
    end

  end
end
