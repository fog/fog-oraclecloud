module Fog
  module OracleCloud
    class Database
      class Real
      	def list_patches(db_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{db_name}/patches"
          )
          response
        end
      end

      class Mock
        def list_patches(db_name)
          response = Excon::Response.new

          # Fake a patch
          response.body = {
            'availablePatches' => [{
              "patchId"=>"23054246-SE",
              "patchNumber"=>"Patch_12.1.0.2.160719_SE",
              "patchCategory"=>"DB",
              "patchSeverity"=>"Normal",
              "includesConfigUpgrade"=>false,
              "patchDescription"=>"DB 12.1.0.2.160719 Jul 2016 PSU Standard Edition image",
              "patchReleaseUrl"=>"https://support.oracle.com/epmos/faces/PatchDetail?patchId=23054246",
              "serviceType"=>"DBaaS",
              "serviceVersion"=>"12.1.0.2",
              "releaseDate"=>"2016-07-16T01:40:00.000+0000",
              "entryDate"=>"2016-10-07T20:57:33.121+0000",
              "entryUserId"=>"OCLOUD9_SM_PLATFORM_APPID",
              "patchType"=>"PSU",
              "requiresRestart"=> true,
              "serviceTypeVersions"=>"ANY",
              "isDeleted"=> false,
              "isCustomerVisible"=> false,
              "isAutoApply"=> false,
              "induceDownTime"=> false,
              "displayName"=>"12.1.0.2.160719",
              "releaseVersion"=>"12.1.0.2.160719",
              "serviceEditions"=>"SE",
            }]
          }
          response
        end
      end
    end
  end
end
