module Fog
  module Compute
    class Oracle
      class Real
      	def create_security_application(name, protocol, options={})
          body_data     = {
            'name'             		=> name,
            'protocol'						=> protocol,
            'dport'								=> options[:dport],
            'icmptype'						=> options[:icmptype],
            'icmpcode'						=> options[:icmpcode],
            'description'					=> options[:description]
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/secapplication/",
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
