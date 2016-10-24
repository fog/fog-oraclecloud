module Fog
  module OracleCloud
    class SOA
      class Real
        def create_instance(config, options)  
          if !config[:cloudStorageContainer].start_with?("/Storage-")
            config[:cloudStorageContainer] = "/Storage-#{@identity_domain}/#{config[:cloudStorageContainer]}"
          end

          parameters = options.select{|key, value| [:adminPassword, :adminPort, :adminUserName, :backupVolumeSize, :clusterName, :contentPort, :dbaName, :dbaPassword, :dbServiceName, :deploymentChannelPort, :domainMode, :domainName, :domainPartitionCount, :domainVolumeSize, :edition, :ipReservations, :managedServerCount, :msInitialHeapMB, :msJvmArgs, :msMaxHeapMB, :msMaxPermMB, :msPermMb, :nodeManagerPassword, :nodeManagerPort, :nodeManagerUserName, :overwriteMsJvmArgs, :pdbName, :securedAdminPort, :securedContentPort, :shape, :VMsPublicKey, :version].include?(key)}
          parameters.reject! { |key,value| value.nil?}
          config.reject! { |key,value| value.nil?}
          # Currently only support weblogic
          parameters[:type] = "weblogic"
          config[:parameters] = [parameters]
          body_data = config

          request({
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/soa/api/v1.1/instances/#{@identity_domain}",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
             'Content-Type'=>'application/json'
            }
          }, false)
        end
      end

      class Mock
        def create_instance(config, options)
          response = Excon::Response.new

          ip = '192.168.1.1'
          data = {
            'status' => 'In Progress',
            'compute_site_name' => 'EM002_Z11',
            'content_url' => "http://#{ip}",
            'created_by' => @username,
            'creation_job_id' => Random.rand(100000),
            'creation_time'=> Time.now.strftime('%Y-%b-%dT%H:%M:%S'),
            'last_modified_time'=> Time.now.strftime('%Y-%b-%dT%H:%M:%S'),
            'service_id' => Random.rand(100000),
            'service_type' => config[:topology],
            'service_uri'=>"#{@region_url}/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{config[:serviceName]}",
           }
            .merge(config.select {|key, value| [:serviceName, :description, :level, :subscriptionType].include?(key) })
            .merge(options.select {|key, value| [:shape, :version].include?(key) }).collect{|k,v| [k.to_s, v]}.to_h

          self.data[:instances][config[:serviceName]] = data
          self.data[:created_at][config[:serviceName]] = Time.now

          server = {
            "name": "#{data['serviceName'][0,8]}_server_1",
            "shape": data['shape'],
            "nodeType": "WLS",
            "isAdmin": true,
            "hostname": ip,
            "status": "Ready",
            "storageAllocated": 74752,
            "creationDate": Time.now.strftime('%Y-%b-%dT%H:%M:%S')
          }
          self.data[:servers][data['serviceName']] = [server]

          response.status = 202
          response
        end
      end
    end
  end
end
