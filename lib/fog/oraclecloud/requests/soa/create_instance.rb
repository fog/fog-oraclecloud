module Fog
  module Oracle
    class SOA
      class Real

        def create_instance(service_name, topology, cloudStorageContainer, cloudStorageUser, cloudStoragePassword, parameters, options={})
          body_data     = {
            'serviceName'             => service_name,
            'topology'                => topology,
            'cloudStorageContainer'   => cloudStorageContainer,
            'cloudStorageUser'        => cloudStorageUser,
            'cloudStoragePassword'    => cloudStoragePassword,
            'parameters'              => parameters,
            'level'                   => options[:level],
            'subscriptionType'        => options[:subscriptionType],
            'description'             => options[:description],
            'sampleAppDeploymentRequests' => options[:sampleAppDeploymentRequests]
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/soa/api/v1.1/instances/#{@identity_domain}",
            :body     => Fog::JSON.encode(body_data),
            #:headers  => {
            #	'Content-Type'=>'application/vnd.com.oracle.oracloud.provisioning.Service+json'
            #}
          )
        end

      end

      class Mock
        def create_instance(service_name, topology, cloudStorageContainer, cloudStorageUser, cloudStoragePassword, parameters, options={})
      		response = Excon::Response.new

      		instance = Fog::Oracle::Mock.create_instance(service_name)
          self.data[:instances][service_name] = instance

      		response.status = 202
          response.headers['Location'] =  "https://jaas.oraclecloud.com/paas/service/dbcs/api/v1.1/instances/agriculture/status/create/job/2781084"
          response
      	end
      end
    end
  end
end
