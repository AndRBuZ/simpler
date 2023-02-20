require_relative 'router/route'

module Simpler
  class Router
    def initialize
      @routes = []
    end

    def get(path, route_point)
      add_route(:get, path, route_point)
    end

    def post(path, route_point)
      add_route(:post, path, route_point)
    end

    def route_for(env)
      method = env['REQUEST_METHOD'].downcase.to_sym
      path = env['PATH_INFO']
      check_path_params(method, path)
      find_route(method, path)
    end

    private

    def check_path_params(method, path)
      path_with_params = path.split('/')
      path_find(method, path, path_with_params) if path_with_params[2].to_i
    end

    def path_find(method, path, path_with_params)
      path_with_params[2] = ':id'
      controller = path_with_params[1]
      path_with_params = path_with_params.join('/')
      route_with_params = find_route(method, path_with_params)
      route_point = controller + '#' + route_with_params.action

      add_route(method, path, route_point)
    end

    def find_route(method, path)
      @routes.find { |route| route.match?(method, path) }
    end

    def add_route(method, path, route_point)
      route_point = route_point.split('#')
      controller = controller_from_string(route_point[0])
      action = route_point[1]

      route = Route.new(method, path, controller, action)

      @routes.push(route)
    end

    def controller_from_string(controller_name)
      Object.const_get("#{controller_name.capitalize}Controller")
    end
  end
end
