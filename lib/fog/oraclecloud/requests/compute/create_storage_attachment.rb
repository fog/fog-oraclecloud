require 'securerandom'

module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_storage_attachment (params)
          if !params[:instance_name].start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            params[:instance_name] = "/Compute-#{@identity_domain}/#{@username}/#{params[:instance_name]}"
          end 
          if !params[:storage_volume_name].start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            params[:storage_volume_name] = "/Compute-#{@identity_domain}/#{@username}/#{params[:storage_volume_name]}"
          end               

          params = params.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/network/v1/ipnetwork/",
            :body     => Fog::JSON.encode(params),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end

      class Mock
        def create_storage_attachment (params)
          response = Excon::Response.new

          guid = SecureRandom.uuid
          name = "#{params[:instance_name]}/#{guid}"

          self.data[:storage_attachments][name] = {
            'index' => params[:index],
            'account' => nil,
            'storage_volume_name' => params[:storage_volume_name],
            'hypervisor' => nil,
            'uri' => "#{@api_endpoint}/storage/attachment/#{name}",
            'instance_name' => params[:instance_name],
            'state' => 'attaching',
            'readonly' => false,
            'name' => name
          }
          response.status = 201
          response.body = self.data[:storage_attachments][name]
          response
        end
      end
    end
  end
end
