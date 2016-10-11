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

          # Also create some compute nodes 
          node = {
            "status"=>"Running",
            "creation_job_id"=>"5495118",
            "creation_time"=>"Tue Jun 28 23:52:45 UTC 2016",
            "created_by"=>"dbaasadmin",
            "shape"=>"oc4",
            "sid"=>"ORCL1",
            "pdbName"=>"PDB1",
            "listenerPort"=> 1521,
            "connect_descriptor"=>"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=db12c-xp-rac2)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=db12c-xp-rac1)(PORT=1521))(LOAD_BALANCE=ON)(FAILOVER=ON))(CONNECT_DATA=(SERVICE_NAME=PDB1.usexample.oraclecloud.internal)))",
            "connect_descriptor_with_public_ip"=>"(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=129.144.23.176)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=129.144.23.112)(PORT=1521))(LOAD_BALANCE=ON)(FAILOVER=ON))(CONNECT_DATA=(SERVICE_NAME=PDB1.usexample.oraclecloud.internal)))",
            "initialPrimary"=> true,
            "storageAllocated"=> 97280,
            "reservedIP"=>"129.144.23.112",
            "hostname"=>"db12c-xp-rac1"
          }
          self.data[:servers][service_name] = [node]
          
          response.status = 202
          response
      	end
      end
    end
  end
end
