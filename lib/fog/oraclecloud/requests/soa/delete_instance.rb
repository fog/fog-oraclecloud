module Fog
  module OracleCloud
    class SOA
      class Real

        def delete_instance(service_name, dba_name, dba_password, options={})
          body_data = {
            'dbaName'     => dba_name,
            'dbaPassword' => dba_password,
            'forceDelete' => options[:force_delete],
            'skipBackupOnTerminate' => options[:skip_backup]
          }

          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'PUT',
            :expects  => 202,
            :path     => "/paas/service/soa/api/v1.1/instances/#{@identity_domain}/#{service_name}",
            :body     => Fog::JSON.encode(body_data)
          )
        end
      end

      class Mock
        def delete_instance(name, dba_name, dba_password, options={})
          response = Excon::Response.new
          self.data[:instances][name]['status'] = 'Terminating'
          self.data[:deleted_at][name] = Time.now
          response.status = 204
          response
        end
      end
    end
  end
end
