module Fog
  module OracleCloud
    class Java
      class Real
      	def get_restoration(service_name, job_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/restoredbackups/#{job_id}"
          )
          response
        end
      end

      class Mock
        def get_restoration(service_name, job_id)
          response = Excon::Response.new
          
          if restoration = self.data[:restorations].first    
            response.status = 200           
            response.body =  restoration
            
            response
          else
            raise Fog::OracleCloud::Java::NotFound.new("Java Server #{name} does not exist");
          end
         
        end
      end
    end
  end
end
