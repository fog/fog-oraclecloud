require 'pp'

Shindo.tests('Fog::Database[oraclecloud] | database requests', 'database') do
	
	tests("#database-create", "create") do
		#db = Fog::OracleCloud[:database].instances.create(
		#	:service_name => 'TestDB',
		#	:description => 'A new database',
		#	:edition => 'SE',
		#	:ssh_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlDbUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ==',
		#	:shape => 'oc3',
		#	:version => '12.1.0.2',
		#	:backup_destination => 'NONE',
		#	:admin_password => 'Welcome1#',
		#	:usable_storage => '15'
		#)
		# Minimum options
		db = Fog::OracleCloud[:database].instances.create(
			:service_name => 'TestDB',
			:ssh_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlDbUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ==',
			:admin_password => 'Welcome1#',
		)


		test "can create a database" do
			db.is_a? Fog::OracleCloud::Database::Instance
		end	

		test "is being built" do
			!db.ready?
		end
		db.wait_for { ready? }

		test "is built" do
			db.ready?
			db.shape == 'oc3'
		end

		test "scale up instance" do
			db.scale('oc4')
			db.wait_for { ready? }
			db.shape == 'oc4'
		end

		test "can add extra storage" do
			db.add_storage(1)
			db.wait_for { ready? }
			db.ready?
		end

		test "can expand storage" do
			db.expand_storage(1)
			db.wait_for { ready? }
			db.ready?
			db.expand_storage(1, 'backup')
			db.wait_for { ready? }
			db.ready?
		end
	end

	tests("#database-attributes", "attributes") do
		tests("should check shape").raises(ArgumentError) do
			instance = Fog::OracleCloud[:database].instances.new({
				:shape => 'fsdfsdf'
			})
		end
		tests("should check service_name").raises(ArgumentError) do
			instance = Fog::OracleCloud[:database].instances.new({
				:service_name => 'Has_Underscore'
				})
		end
	end

	tests('#database-read') do
		instances = Fog::OracleCloud[:database].instances.all

		test "returns an Array" do
			instances.is_a? Array
		end
	
		test "should return records" do
			instances.size >= 1
		end

		test "should return a valid name" do
			instances.first.service_name.is_a? String
		end

		instance = Fog::OracleCloud[:database].instances.get(instances.first.service_name)
		test "should return an instance" do
			instance.service_name.is_a? String
		end
		servers = instance.servers
		test "should have compute nodes" do
			servers.is_a? Array
			servers.size >= 1
			servers.first.status.is_a? String
		end

		test "has special attributes" do
			instance.failover_database == 'no'
		end
	end

	tests("#database-backups-create", "create") do
		instance = Fog::OracleCloud[:database].instances.first
		instance.backup()
		test "backup created" do
			backups = instance.backups
			backups.is_a? Array
			backups.first.wait_for { completed? }
			backups.first.completed?
		end
	end

	tests("#database-backups", "backups") do
		instance = Fog::OracleCloud[:database].instances.first
		backups = instance.backups
		test "should have backups" do
			backups.is_a? Array
		end
		if backups.size >= 1 then
			test "one of them should have completed" do
				backups.size >= 1
				backups.first.completed?
			end
		end
	end

	tests("#database-access_rules") do
		instance = Fog::OracleCloud[:database].instances.first
		access_rules = instance.access_rules
		test "should get access_rules" do
			access_rules.is_a? Array
		end
		test "should get rule" do
			rule = instance.get_access_rule('ora_p2_ssh')
			rule.ruleName == 'ora_p2_ssh'
		end
	end

	tests("#database-recoveries-create", "create") do
		instance = Fog::OracleCloud[:database].instances.first
		tag = instance.backups.first.db_tag
		instance.recover('tag', tag)
		recoveries = instance.recoveries
		test "can recover by tag" do
			recoveries.is_a? Array
			rec = recoveries.find {|r| r.db_tag == tag}
			rec.is_a? Fog::OracleCloud::Database::Recovery
			rec.wait_for { completed? }
			rec.recovery_complete_date.is_a? String
		end
		test "can recover by latest" do
			instance.recover_latest()
			rec = instance.recoveries.find {|r| !r.latest.nil? }
			rec.is_a? Fog::OracleCloud::Database::Recovery
			rec.latest
			rec.wait_for { completed? }
			rec.recovery_complete_date.is_a? String			
		end
		test "can recover by timestamp" do
			time = Time.now
			instance.recover('timestamp', time)
			rec = instance.recoveries.find {|r| !r.latest.nil? }
			rec.is_a? Fog::OracleCloud::Database::Recovery
			rec.timestamp == time
			rec.wait_for { completed? }
			rec.recovery_complete_date.is_a? String						
		end
		# Need to test SCN. Not sure how to mock test this?
	end

	tests("#database-recoveries", "recoveries") do
		instances = Fog::OracleCloud[:database].instances
		recs = Fog::OracleCloud[:database].recoveries.all(instances.first.service_name)
		test "might have recoveries" do
			recs.is_a? Array
		end
		if recs.size >= 1 then
			test "one of them should have completed" do
				recs.first.completed?
			end
		end
	end

	tests("#database-snapshots-create", "create") do
		instances = Fog::OracleCloud[:database].instances

		snap = Fog::OracleCloud[:database].snapshots.create(
			:name => 'TestSnapshot',
			:description => 'A new snapshot',
			:database_id => instances.first.service_name
		)
		test "can create a snapshot" do
			snap.is_a? Fog::OracleCloud::Database::Snapshot
		end

		test "is being built" do
			!snap.completed?
		end
		snap.wait_for { completed? }

		test "is built" do
			snap.completed?
		end
	end

	tests("#database-snapshots", "snapshots") do
		instances = Fog::OracleCloud[:database].instances
		snaps = instances.first.snapshots
		test "might have snapshots" do
			snaps.is_a? Array
		end
		if snaps.size >= 1 then
			test "one of them should have completed" do
				snaps.first.completed?
			end
			test "can get snapshot" do
				snap = instances.first.get_snapshot(snaps.first.name)
				snap.name.is_a? String
				snap.cloned_services.is_a? Array
				snap.cloned_services.first['clonedServiceName'].is_a? String
			end
		end
	end

	tests("#database-shapshots-delete", "create") do
		db = Fog::OracleCloud[:database].instances.get('TestDB')
		snap = db.snapshots.first
		snap.destroy()
		snap.wait_for { deleting? }
		tests("should actually delete snapshot").raises(Fog::OracleCloud::Database::NotFound) do 
			snap.wait_for { status == 'Stopped' }
		end
	end

	tests("database-patches") do
		instances = Fog::OracleCloud[:database].instances
		patches = instances.first.patches
		test "should have patches" do
			patches.is_a? Array
		end
		if patches.size >= 1 then
			test "has a patch id" do
				patches.first.id.is_a? String
			end
		end
	end

	tests("#database-delete", "create") do
		db = Fog::OracleCloud[:database].instances.get('TestDB')
		db.destroy()
		db.wait_for { stopping? }
		tests("should actually delete instance").raises(Fog::OracleCloud::Database::NotFound) do
			db.wait_for { stopped? } 
		end
	end


end