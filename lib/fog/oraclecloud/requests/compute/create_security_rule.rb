module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_security_rule(name, src_list, dst_list, application, action, options={})
          body_data     = {
            'name'             		=> name,
            'src_list'						=> src_list,
            'dst_list'						=> dst_list,
            'application'					=> application,
            'action'					   	=> action,
            'description'         => options[:description],
            'disabled'            => options[:disabled]
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/secrule/",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
      class Mock
        def create_security_rule(name, src_list, dst_list, application, action, options={})
          response = Excon::Response.new
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          data = {
            'name'                => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'src_list'            => src_list,
            'dst_list'            => dst_list,
            'application'         => application,
            'action'              => action,
            'description'         => options[:description],
            'disabled'            => options[:disabled],
            'uri'                 => "#{@api_endpoint}secrule/#{name}"
          }
          self.data[:security_rules][name] = data

          response.status = 201
          response.body = self.data[:security_rules][name]
          response
        end
      end
    end
  end
end
