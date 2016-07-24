module Fog
  module Compute
    class Oracle
      class Real
      	def delete_ssh_key (name)
          if !name.start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            name = "/Compute-#{@identity_domain}/#{@username}/#{name}"
          end         
          request(
            :method   => 'DELETE',
            :expects  => 204,
            :path     => "/sshkey#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
    end
  end
end
