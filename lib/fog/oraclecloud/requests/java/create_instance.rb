module Fog
  module OracleCloud
    class Java
      class Real

        def create_instance(config, options)
          
          if !config[:cloudStorageContainer].start_with?("/Storage-")
            config[:cloudStorageContainer] = "/Storage-#{@identity_domain}/#{config[:cloudStorageContainer]}"
          end

          config[:parameters] = options.select{|key, value| [:adminPassword, :adminPort, :adminUserName, :backupVolumeSize, :clusterName, :contentPort, :dbaName, :dbaPassword, :dbServiceName, :deploymentChannelPort, :domainMode, :domainName, :domainPartitionCount, :domainVolumeSize, :edition, :ipReservations, :managedServerCount, :msInitialHeapMB, :msJvmArgs, :msMaxHeapMB, :msMaxPermMB, :msPermMb, :nodeManagerPassword, :nodeManagerPort, :nodeManagerUserName, :overwriteMsJvmArgs, :pdbName, :securedAdminPort, :securedContentPort, :shape, :VMsPublicKey].include?(key)}
          config[:parameters].reject! { |key,value| value.nil?}
          config.reject! { |key,value| value.nil?}
          # Currently only support weblogic
          config[:parameters][:type] = "weblogic"

          body_data = config

          request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}",
            :body     => Fog::JSON.encode(body_data),
            #:headers  => {
            # 'Content-Type'=>'application/vnd.com.oracle.oracloud.provisioning.Service+json'
            #}
          )
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
            'db_info' => "#{options[:dbServiceName]}:1521/#{options[:pdbName] || 'PDB1'}.#{@identity_domain}.oraclecloud.internal",
            'deletion_job_id' => 0,
            'domainMode'=>'DEVELOPMENT',
            'fmw_control_url'=> "https://#{ip}:#{options[:adminPort] || 7002}/em",
            'last_modified_time'=> Time.now.strftime('%Y-%b-%dT%H:%M:%S'),
            'num_ip_reservations'=> 2, # Can't rely on this number in mocking mode
            'num_nodes'=>options[:managedServerCount],
            'otd_provisioned'=>options[:provisionOTD] || 'no',
            'psm_plugin_version'=>"16.3.5-532",
            'secure_content_url' => "https://#{ip}",
            'service_type'=>'jaas',
            'service_uri'=>"#{@region_url}/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{config[:serviceName]}",
            'wls_admin_url'=> "https://#{ip}:#{options[:adminPort] || 7002}/console",
            'wls_deployment_channel_port' => options[:deploymentChannelPort] || 9001,
            'wlsVersion'=>'12.2.1.0.160419'
          }
            .merge(config.select {|key, value| [:serviceName, :description, :level, :subscriptionType].include?(key) })
            .merge(options.select {|key, value| [:clusterName, :dbServiceName, :edition, :shape, :version].include?(key) }).collect{|k,v| [k.to_s, v]}.to_h

          if data['clusterName'].nil? then data['clusterName'] = data['serviceName'][0,8] + "_cluster" end
          if data['domainName'].nil? then data['domainName'] = data['serviceName'][0,8] + "_domain" end
          self.data[:instances][config[:serviceName]] = data
          self.data[:created_at][config[:serviceName]] = Time.now

          server = {
            "clusterName": data['clusterName'] || data['serviceName'][0,8] + "_cluster",
            "name": "#{data['serviceName'][0,8]}_server_1",
            "shape": data['shape'],
            "nodeType": "WLS",
            "isAdmin": true,
            "hostname": ip,
            "status": "Ready",
            "storageAllocated": 74752,
            "creationDate": Time.now.strftime('%Y-%b-%dT%H:%M:%S')
          }
          self.data[:servers][data['serviceName']] = {}
          self.data[:servers][data['serviceName']][server[:name]] = server


          # Add default access rules
          access_rules = [{
            "ruleName" => "sys_ms2db_dblistener",
            "description"=> "DO NOT MODIFY=> Permit listener connection to database from managed servers",
            "status"=> "enabled",
            "source"=> "WLS_MANAGED_SERVER",
            "destination"=> "dbaas=>nbnws=>DB",
            "ports"=> "1521",
            "protocol"=> "tcp",
            "ruleType"=> "SYSTEM"
          },{
            "ruleName"=> "sys_ms2db_ssh",
            "description"=> "DO NOT MODIFY=> Permit managed servers to ssh to db",
            "status"=> "enabled",
            "source"=> "WLS_MANAGED_SERVER",
            "destination"=> "dbaas=>nbnws=>DB",
            "port"=> "22",
            "portocol"=> "tcp",
            "ruleType"=> "SYSTEM"
          },{
            "ruleName"=> "ora_p2admin_ssh",
            "description"=> "DO NOT MODIFY=> Permit public ssh to admin server",
            "status"=> "enabled",
            "source"=> "PUBLIC-INTERNET",
            "destination"=> "WLS_ADMIN_SERVER",
            "port"=> "22",
            "portocol"=> "tcp",
            "ruleType"=> "DEFAULT"
          },{
            "ruleName"=> "ora_p2admin_ahttps",
            "description"=> "DO NOT MODIFY=> Permit public to https to admin server",
            "status"=> "enabled",
            "source"=> "PUBLIC-INTERNET",
            "destination"=> "WLS_ADMIN_SERVER",
            "port"=> "7002",
            "portocol"=> "tcp",
            "ruleType"=> "DEFAULT"
          },{
            "ruleName"=> "sys_infra2admin_ssh",
            "description"=> "DO NOT MODIFY=> Permit PSM to ssh to admin server",
            "status"=> "enabled",
            "source"=> "PAAS-INFRA",
            "destination"=> "WLS_ADMIN_SERVER",
            "port"=> "22",
            "portocol"=> "tcp",
            "ruleType"=> "DEFAULT"
          },{
            "ruleName"=> "ora_p2ms_chttp",
            "description"=> "Permit http connection to managed servers from public",
            "status"=> "enabled",
            "source"=> "PUBLIC-INTERNET",
            "destination"=> "WLS_ADMIN_SERVER",
            "port"=> "80",
            "portocol"=> "tcp",
            "ruleType"=> "DEFAULT"
          },{
            "ruleName"=> "ora_p2ms_chttps",
            "description"=> "Permit https connection to managed servers from public",
            "status"=> "enabled",
            "source"=> "PUBLIC-INTERNET",
            "destination"=> "WLS_MANAGED_SERVER",
            "port"=> "443",
            "portocol"=> "tcp",
            "ruleType"=> "DEFAULT"
          }]

          self.data[:access_rules][data['serviceName']] = access_rules

          response.status = 202
          response
        end
      end
    end
  end
end
