module Fog
  module OracleCloud
    class Java
      class Real

      	def get_server(service_name, server_name)
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/servers/#{server_name}"
          )
          response
        end
      end

      class Mock
        def get_server(service_name, server_name)
          response = Excon::Response.new

          if server = self.data[:servers][service_name][server_name]
            case server[:status]
            when 'Maintenance'
              info = self.data[:maintenance_at][server_name]
              if Time.now - info['time'] >= Fog::Mock.delay
                self.data[:servers][service_name][server_name][:status] = 'Ready'
                self.data[:servers][service_name][server_name][info['attribute']] = info['value']
                self.data[:maintenance_at].delete(server_name)
              end
            end
            response.status = 200
            response.body = server
            response
          else
            raise Fog::OracleCloud::Java::NotFound.new("Java Server #{name} does not exist");
          end
        end
      end
    end
  end
end