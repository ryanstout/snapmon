desc "Sets up monitoring through Snapmon.com, requires snapmon.yml"
task :setup_monitor do
	require File.join(File.dirname(__FILE__), '../lib/', 'snapmon_setup')

	SnapmonSetup.new
end
