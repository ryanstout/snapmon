# When the SnapMon plugin is installed run the snapmon_config generator
puts "Testing install"

begin
	require 'rails_generator'
	require 'rails_generator/scripts/generate'

	Rails::Generator::Scripts::Generate.new.run(['snapmon_config'])
rescue Exception => e
	puts e.inspect
end