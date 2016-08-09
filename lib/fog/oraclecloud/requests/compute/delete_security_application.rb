module Fog
  module Compute
    class Oracle
      class Real
      	def delete_security_application(name)
      		# Just in case it's already set
      		name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
	      	request(
            :method   => 'DELETE',
            :expects  => 204,
            :path     => "/secapplication/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
    end
  end
end
