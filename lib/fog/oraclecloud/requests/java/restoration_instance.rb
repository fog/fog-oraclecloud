module Fog
  module OracleCloud
    class Java
      class Real

      	def restoration_instance(service_name, backup_id, options={})
          body_data     = {
            'backupId' => backup_id,
            'forceScaleIn' => options[:forceScaleIn],           
            'notes'             => options[:notes], 
            'pauseOTD' =>  options[:pauseOTD],
            'resetBinaries' =>  options[:resetBinaries],
            'restoreConfig' =>  options[:restoreConfig]
          }
          body_data = body_data.reject {|key, value| value.nil?}
        
          response = request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/restoredbackups",
            :body     => Fog::JSON.encode(body_data),
          )
          
          response
          
        end
      end

      class Mock
        def restoration_instance(service_name, backup_id, options={})
      		response = Excon::Response.new

          if !self.data[:restorations].is_a? Array then 
            self.data[:restorations] = []
          end
          
          self.data[:restorations].push({
            'jobId'=>'10001',
            'backupId'=>backup_id,
            'recoveryStartDate'=>Time.now.strftime('%d-%b-%Y %H:%M:%S UTC'),
            'status'=>'Completed',
            'service_name'=>service_name
          })
          
          response.status = 202 
          response.body={
            'operationName'=>'restore-backup'
          }         
          response
      	end
      end
    end
  end
end
