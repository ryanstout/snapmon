desc "Sets up monitoring through Snapmon.com, requires snapmon.yml"
namespace :snapmon do
	desc "Sets up monitoring through Snapmon.com, requires snapmon.yml"
	task :setup do
		require File.join(File.dirname(__FILE__), '../', 'snapmon_setup')
		SnapmonSetup.new.upload_config
	end
	
	desc "Unpause all host monitors"
	task :enable do
		require File.join(File.dirname(__FILE__), '../', 'snapmon_setup')
		SnapmonSetup.new.enable
	end

	desc "Pause all host monitors"
	task :disable do
		require File.join(File.dirname(__FILE__), '../', 'snapmon_setup')
		SnapmonSetup.new.disable
	end
end