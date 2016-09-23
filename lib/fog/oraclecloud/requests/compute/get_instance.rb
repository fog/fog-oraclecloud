module Fog
  module Compute
    class OracleCloud
      class Real
				def get_instance(name)
          if !name.start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            name = "/Compute-#{@identity_domain}/#{@username}/#{name}"
          end
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/instance#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def get_instance(name)
          response = Excon::Response.new
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          if instance = self.data[:instances][name] 
            if instance['state'] == 'stopping'
              self.data[:instances].delete(name)
              raise Fog::Compute::OracleCloud::NotFound.new("Instance #{name} does not exist");
            else;
              response.status = 200
              response.body = instance
              response
            end
          else;
            raise Fog::Compute::OracleCloud::NotFound.new("Instance #{name} does not exist");
          end
        end
      end
    end
  end
end
