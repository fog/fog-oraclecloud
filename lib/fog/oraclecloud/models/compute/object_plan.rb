module Fog
  module Compute
  	class Oracle
	    class ObjectPlan < Fog::Model

	      attribute :label
	      attribute :obj_type
	      attribute :objects

	      def object_type
					obj_type     	
	      end   
	    end
	  end
  end
end
