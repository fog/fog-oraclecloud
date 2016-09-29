module Fog
  module OracleCloud
    class Database
      class Real

      	def create_instance(service_name, edition, vmPublicKey, shape, version, options={})
          body_data     = {
            'serviceName'             => service_name,
            'version'                 => options[:version],
            'level'										=> options[:level],
            'edition'                 => edition,
            'subscriptionType'				=> options[:subscriptionType],
            'description'							=> options[:description],
            'shape'                   => options[:shape],
            'vmPublicKeyText'         => vmPublicKey,
            'parameters'              => {
              'shape'                   => shape,
              'version'                 => version
            }
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
        def create_instance(service_name, edition, vmPublicKey, shape, version, options={})
      		response = Excon::Response.new

          data = {
            'service_name' => service_name,
            'shape' => shape,
            'edition' => edition,
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
