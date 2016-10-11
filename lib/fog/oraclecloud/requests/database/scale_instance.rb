module Fog
  module OracleCloud
    class Database
      class Real

      	def scale_instance(name, options={})
          body_data     = {
            'shape'             => options[:shape],
            'additionalStorage' => options[:additional_storage],
            'usage'             => options[:usage]
          }
          body_data = body_data.reject {|key, value| value.nil?}
        
          request(
            :method   => 'PUT',
            :expects  => 202,
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{name}",
            :body     => Fog::JSON.encode(body_data),
          )
        end
      end

      class Mock
        def scale_instance(name, options={})
      		response = Excon::Response.new

          self.data[:instances][name]['status'] = 'Maintenance'
          info = { 'time'=> Time.now }
          if (options[:shape]) then
            info['attribute'] = 'shape'
            info['value'] = options[:shape]
          end
          self.data[:maintenance_at][name] = info
          response.status = 202
          response
      	end
      end
    end
  end
end
