# When installed as a plugin this is loaded automatically.
#
# When installed as a gem, you need to add 
#  require 'snapmon/recipes'
# to your deploy.rb
#
#


configuration = Capistrano::Configuration.respond_to?(:instance) ? Capistrano::Configuration.instance(:must_exist) : Capistrano.configuration(:must_exist)

configuration.load do
	namespace :deploy do
    
    # on all deployments, notify RPM 
    desc "Sets up monitoring through Snapmon.com, requires snapmon.yml"
    task :setup_monitor, :roles => :db, :except => {:no_release => true } do
			require File.join(File.dirname(__FILE__), '..', 'snapmon_setup')

			SnapmonSetup.new
    end
  end

	after "deploy:restart", "deploy:setup_monitor"
	
end
