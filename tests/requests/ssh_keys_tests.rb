Shindo.tests('Fog::Compute[oracle] | ssh_keys requests', 'ssh_keys') do

	tests("#sshkeys-create", "create") do
		sshkey = Fog::Compute[:oracle].ssh_keys.create(
			:name 		=> 'TestSSHKey2',
			:enabled 	=> false,
			:key			=> 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlDbUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ=='
		)

		test "can create an sshkey" do
			sshkey.is_a? Fog::Compute::Oracle::SshKey
			sshkey.uri.is_a? String
		end

		check = Fog::Compute[:oracle].ssh_keys.get(sshkey.name)
		test "can get ssh key" do
			check.uri == sshkey.uri
		end

		sshkey.enabled = true
		sshkey.save()
		test "can update ssh key" do
			check = Fog::Compute[:oracle].ssh_keys.get(sshkey.name)
			check.enabled == true
		end
		sshkey.destroy()
		tests("can delete ssh key").raises(Excon::Error::NotFound) do
			check = Fog::Compute[:oracle].ssh_keys.get(sshkey.name)
		end
	end

	tests("#sshkeys-read") do
		sshkeys = Fog::Compute[:oracle].ssh_keys
		test "returns an Array" do
			sshkeys.is_a? Array
		end
		test "should return keys" do
			sshkeys.size >= 1
		end
		test "should return a valid name" do
			sshkeys.first.name.is_a? String
		end

		sshkey = Fog::Compute[:oracle].ssh_keys.get(sshkeys.first.name)
		test "should return a key" do
			sshkey.name.is_a? String
		end
	end
end