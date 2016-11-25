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
          
          restoration = {}
          self.data[:restorations].each_with_index{ |r,i|
            if r['jobId'].eql?(job_id)
              restoration = self.data[:restorations][i]
            end 
          }
           
          response.status = 200           
          response.body =  restoration
          response
       
        end
      end
    end
  end
end
