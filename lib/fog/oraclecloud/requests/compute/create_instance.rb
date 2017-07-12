module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_instance (name, shape, imagelist, label, sshkeys)
          # This will create an instance using a Launchplan. Consider using an orchestration plan for more control
          # Just in case it's already set
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          body_data     = {
            'instances'    => [{
              'name'             		=> "/Compute-#{@identity_domain}/#{@username}/#{name}",
              'shape'					      => shape,
              'imagelist'					  => imagelist,
              'label'               => label,
              'sshkeys'             => sshkeys
            }]
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/launchplan/",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end

      class Mock
        def create_instance (name, shape, imagelist, label, sshkeys)
          response = Excon::Response.new
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          self.data[:instances][name] = {
            'name' => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'shape' => shape,
            'imagelist' => imagelist,
            'label' => label,
            'sshkeys' => sshkeys,
            'state' => 'running',
            'account' => "/Compute-#{@identity_domain}/default",
            'boot_order' => [],
            'disk_attach' => '',
            'domain' => "compute-#{@identity_domain}.oraclecloud.internal",
            'entry' => 1,
            'error_reason' => '',
            'hostname' => "mock.compute-#{@identity_domain}.oraclecloud.internal",
            'hypervisor' => {"mode"=>"hvm"},
            'image_format' => 'raw',
            'ip' => '127.0.0.1',
            'networking'=> {
              "eth0"=>{
                "model"=>"", 
                "seclists"=>["/Compute-#{@identity_domain}/default/default"], 
                "dns"=>["mock.compute-#{@identity_domain}.oraclecloud.internal."], 
                "vethernet"=>"/oracle/public/default",
                "nat"=>nil
              }
            },
            'placement_requirement' => ["/system/compute/placement/default", "/system/compute/allow_instances"],
            'platform' => 'linux', # Probably? Don't rely on this in mock
            'priority' => '/oracle/public/default',
            'quota' => "/Compute-#{@identity_domain}",
            'quota_reservation' => nil,
            'resolvers' => nil,
            'reverse_dns' => true,
            'site' => '',
            'storage_attachments' => [],
            'tags' => [],
            'uri'=>"#{@api_endpoint}/instance/Compute-#{@identity_domain}/#{@username}/#{name}",
            'vcable_id'=>"/Compute-#{@identity_domain}/#{@username}/", # TODO: add random id
            'virtio'=>nil,
            'vnc'=>'127.0.0.1:5900'
          }
          response.status = 201
          response.body = {
            'instances' => [self.data[:instances][name]]
          }
          response
        end
      end
    end
  end
end
