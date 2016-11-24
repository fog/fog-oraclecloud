module Fog
  module OracleCloud
    class Java
      class Real
      	def list_backups(service_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/backups"
          )
          response
        end
      end

      class Mock
        def list_backups(service_name)
          response = Excon::Response.new

          if !self.data[:backups] then 
            self.data[:backups] = [] 
          end
          
          backups = self.data[:backups]        
          response.body = {
            'backups' => backups
          }
          response
        end
      end
    end
  end
end
