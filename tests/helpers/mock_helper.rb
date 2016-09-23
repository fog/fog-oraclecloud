# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

puts "Mock: #{Fog.mock?}"
# if in mocked mode, fill in some fake credentials for us
if Fog.mock?
  Fog.credentials = {
  	:oracle_compute_api => 'https://api.compute.us0.oraclecloud.com'
  }.merge(Fog.credentials)
end