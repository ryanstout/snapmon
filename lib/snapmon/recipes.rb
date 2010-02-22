# When installed as a plugin this is loaded automatically.
#
# When installed as a gem, you need to add 
#  require 'snapmon/recipes'
# to your deploy.rb
#
#


configuration = Capistrano::Configuration.respond_to?(:instance) ? Capistrano::Configuration.instance(:must_exist) : Capistrano.configuration(:must_exist)

configuration.load do
	namespace :snapmon do
    desc "Sets up monitoring through Snapmon.com, requires snapmon.yml"
    task :setup, :roles => :db, :except => {:no_release => true } do
			require File.join(File.dirname(__FILE__), '..', 'snapmon_setup')
			SnapmonSetup.new.upload_config
    end

    desc "Unpause all host monitors"
    task :enable, :roles => :db, :except => {:no_release => true } do
			require File.join(File.dirname(__FILE__), '..', 'snapmon_setup')
			SnapmonSetup.new.enable
    end

    desc "Pause all host monitors"
    task :disable, :roles => :db, :except => {:no_release => true } do
			require File.join(File.dirname(__FILE__), '..', 'snapmon_setup')
			SnapmonSetup.new.disable
    end
  end

	after "deploy:restart", "snapmon:setup"
	
end
