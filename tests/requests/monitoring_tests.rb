require 'pp'

Shindo.tests('Fog::OracleCloud | monitoring requests') do
	tests("#metrics report") do
		reports = Fog::OracleCloud[:monitoring].metrics_reports.all
		test "get metrics reports" do
			pp reports
			reports.is_a? Array
		end
	end
end