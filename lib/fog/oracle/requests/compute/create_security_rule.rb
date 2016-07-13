module Fog
  module Compute
    class Oracle
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
    end
  end
end
