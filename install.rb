# When the SnapMon plugin is installed run the snapmon_config generator
puts "Testing install"

require 'rails_generator'
require 'rails_generator/scripts/generate'

ARGV = ['snapmon']
Rails::Generator::Scripts::Generate.new.run(['snapmon_config'])