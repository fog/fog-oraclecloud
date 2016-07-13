module Fog
  module Compute
    class Oracle
      class Real
      	def create_volume(name, size, high_latency = false, options={})
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", '' # Just in case it's already set
          body_data     = {
            'name'             		=> "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'size'						    => size,
            'properties'          => []
          }
          body_data.properties.push(high_latency ? "/oracle/public/storage/latency" : '/oracle/public/storage/default')
          body_data = body_data.reject {|key, value| value.nil?}
          puts body_data

          #request(
          #  :method   => 'POST',
          #  :expects  => 201,
          #  :path     => "/volume/",
          #  :body     => Fog::JSON.encode(body_data),
          # :headers  => {
          #   'Content-Type' => 'application/oracle-compute-v3+json'
          #  }
          #)
      	end
      end
    end
  end
end
