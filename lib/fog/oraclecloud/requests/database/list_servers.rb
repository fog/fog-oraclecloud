module Fog
  module OracleCloud
    class Database
      class Real
      	def list_servers(db_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{db_name}/servers"
          )
          response
        end
      end

      class Mock
        def list_servers(db_name)
          response = Excon::Response.new

          servers = self.data[:servers][db_name]

          response.body = servers
          response
        end
      end
    end
  end
end
