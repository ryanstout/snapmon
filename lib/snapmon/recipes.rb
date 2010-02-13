# When installed as a plugin this is loaded automatically.
#
# When installed as a gem, you need to add 
#  require 'snapmon/recipes'
# to your deploy.rb
#
#
snapmon_setup_lm = lambda do
  
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
require 'capistrano/version'
if Capistrano::Version::MAJOR < 2
  STDERR.puts "Unable to load #{__FILE__}\nNew Relic Capistrano hooks require at least version 2.0.0"
else
  instance = Capistrano::Configuration.instance
  if instance
    instance.load &snapmon_setup_lm
  else
    snapmon_setup_lm.call
  end
end