module Fog
  module Oracle
    class Java
      class Real

        def delete_instance(service_name, dba_name, dba_password, options={})
          body_data = {
            'dbaName'     => dba_name,
            'dbaPassword' => dba_password,
            'forceDelete' => options[:force_delete]
          }

          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'PUT',
            :expects  => 202,
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
              'Content-Type'=>'application/vnd.com.oracle.oracloud.provisioning.Service+json'
            }
          )
        end
      end

      class Mock
        def delete_instance(service_name, dba_name, dba_password, options={})
          response = Excon::Response.new
            # remove from memoreeeez.
          self.data[:instances].delete service_name
          response.body = { 
            'service_name' => service_name,
            'status' => 'Terminating' 
          }
          response.status = 202
      
          response
        end
      end
    end
  end
end
