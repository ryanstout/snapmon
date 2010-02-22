desc "Sets up monitoring through Snapmon.com, requires snapmon.yml"
namespace :snapmon do
	task :setup do
		require File.join(File.dirname(__FILE__), '../lib/', 'snapmon_setup')
		SnapmonSetup.new.upload_config
	end
	
	task :enable do
		require File.join(File.dirname(__FILE__), '../lib/', 'snapmon_setup')
		SnapmonSetup.new.enable
	end

	task :disable do
		require File.join(File.dirname(__FILE__), '../lib/', 'snapmon_setup')
		SnapmonSetup.new.disable
	end
end