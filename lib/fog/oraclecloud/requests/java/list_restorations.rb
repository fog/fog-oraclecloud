module Fog
  module OracleCloud
    class Java
      class Real
      	def list_restorations(service_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/restoredbackups"
          )
          response
        end
      end

      class Mock
        def list_restorations(service_name)
          response = Excon::Response.new

          if !self.data[:restorations] then
             self.data[:restorations] = [] 
          end
          
          restorations = self.data[:restorations]
          response.body = {
            'restoreHistory' => restorations
          }
          response
        end
      end
    end
  end
end
