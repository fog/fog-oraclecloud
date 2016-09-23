module Fog
  module Compute
    class OracleCloud
      class Real
        def get_ssh_key(name)
          if !name.start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            name = "/Compute-#{@identity_domain}/#{@username}/#{name}"
          end
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/sshkey#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def get_ssh_key(name)
          response = Excon::Response.new

          if sshkey = self.data[:sshkeys][name] 
            response.status = 200
            response.body = sshkey
            response
          else;
            raise Fog::Compute::OracleCloud::NotFound.new('SSHKey does not exist');
          end
        end
      end
    end
  end
end
