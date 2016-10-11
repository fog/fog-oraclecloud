require 'fog/core/model'

module Fog
  module OracleCloud
    class Database
      class Patch < Fog::Model
        identity  :id, :aliases=>'patchId'

        attribute :number,                  :aliases=>'patchNumber'
        attribute :category,                :aliases=>'patchCategory'
        attribute :severity,                :aliases=>'patchSeverity'
        attribute :includes_config_upgrade, :aliases=>'includesConfigUpgrade'
        attribute :description,             :aliases=>'patchDescription'
        attribute :release_url,             :aliases=>'patchReleaseUrl'
        attribute :service_type,            :aliases=>'serviceType'
        attribute :service_version,         :aliases=>'serviceVersion'
        attribute :release_date,            :aliases=>'releaseDate'
        attribute :entry_date,              :aliases=>'entryDate'
        attribute :entry_user_id,           :aliases=>'entryUserId'
        attribute :patch_type,              :aliases=>'patchType'
        attribute :requires_restart,        :aliases=>'requiresRestart'
        attribute :is_deleted,              :aliases=>'isDeleted'
        attribute :is_customer_visible,     :aliases=>'isCustomerVisible'
        attribute :is_auto_apply,           :aliases=>'isAutoApply'
        attribute :induce_down_time,        :aliases=>'induceDownTime'
        attribute :display_name,            :aliases=>'displayName'
        attribute :release_version,         :aliases=>'releaseVersion'
        attribute :service_editions,        :aliases=>'serviceEditions'
      
       
      end
    end
  end
end
