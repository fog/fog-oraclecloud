require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class Shape < Fog::Model
	      identity  :name

	      attribute :cpus
	      attribute :gpus
	      attribute :io
	      attribute :is_root_ssd
	      attribute :nds_iops_limit
	      attribute :placement_requirements
	      attribute :ram
	      attribute :root_disk_size
	      attribute :ssd_data_size
	      attribute :uri

	    end
	  end
  end
end
