module Fog
  module Oracle
    class Database
      class Real

      	def create_instance(service_name, edition, vmPublicKey, parameters, options={})
          body_data     = {
            'serviceName'             => service_name,
            'version'                 => options[:version],
            'level'										=> options[:level],
            'edition'                 => edition,
            'subscriptionType'				=> options[:subscriptionType],
            'description'							=> options[:description],
            'shape'                   => options[:shape],
            'vmPublicKeyText'         => vmPublicKey,
            'parameters'              => parameters
          }
          body_data = body_data.reject {|key, value| value.nil?}
        
          request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}",
            :body     => Fog::JSON.encode(body_data),
            #:headers  => {
            #	'Content-Type'=>'application/vnd.com.oracle.oracloud.provisioning.Service+json'
            #}
          )
        end

      end

      class Mock
        def create_instance(service_name, edition, vmPublicKey, parameters, options={})
      		response = Excon::Response.new

      		instance = Fog::Oracle::Mock.create_database_instance(service_name)
          self.data[:instances][service_name] = instance

      		response.status = 202
          response
      	end
      end
    end
  end
end
