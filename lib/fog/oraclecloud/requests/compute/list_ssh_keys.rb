module Fog
  module Compute
    class OracleCloud
      class Real
      	def list_ssh_keys
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/sshkey/Compute-#{@identity_domain}/"
          )
          response
        end
      end

      class Mock
        def list_ssh_keys
          response = Excon::Response.new

          sshkeys = self.data[:sshkeys].values

          response.body = {
            'result' => sshkeys
          }
          response
        end
      end
    end
  end
end
