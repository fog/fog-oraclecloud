module Fog
  module OracleCloud
    class Java
      class Real

        def create_instance(service_name, cloudStorageContainer, cloudStorageUser, cloudStoragePassword, dbaName, dbaPassword, dbServiceName, shape, version, vmPublicKey, options={})
          if !cloudStorageContainer.start_with?("/Storage-") then
            # They haven't provided a well formed container name, add their details in
            name = "/Storage-#{@identity_domain}/#{@username}/#{cloudStorageContainer}"
          end   
          body_data     = {
            'serviceName'             => service_name,
            'cloudStorageContainer'		=> cloudStorageContainer,
            'cloudStorageUser'				=> cloudStorageUser,
            'cloudStoragePassword'		=> cloudStoragePassword,
            'parameters'							=> parameters,
            'level'										=> options[:level],
            'subscriptionType'				=> options[:subscriptionType],
            'description'							=> options[:description],
            'provisionOTD'						=> options[:provisionOTD],
            'sampleAppDeploymentRequests' => options[:sampleAppDeploymentRequests]
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
            	'Content-Type'=>'application/vnd.com.oracle.oracloud.provisioning.Service+json'
            }
          )
        end

      end
      class Mock
        def create_instance(service_name, cloudStorageContainer, cloudStorageUser, cloudStoragePassword, dbaName, dbaPassword, dbServiceName, shape, version, vmPublicKey, options={})
          response = Excon::Response.new

          data = {
            'service_name' => service_name,
            'db_service_name' => dbServiceName,
            'shape' => shape,
            'version' => version,
            'status' => 'In Progress'
          }.merge(options.select {|key, value| ["description"].include?(key) })

          self.data[:instances][service_name] = data
          self.data[:created_at][service_name] = Time.now
          response.status = 202
          response
        end
      end
    end
  end
end
