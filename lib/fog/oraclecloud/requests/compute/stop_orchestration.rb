module Fog
  module Compute
    class OracleCloud
      class Real
      	def stop_orchestration (name)
          if !name.start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            name = "/Compute-#{@identity_domain}/#{@username}/#{name}"
          end   
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/orchestration#{name}?action=stop",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
    end
  end
end
