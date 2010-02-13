# When the SnapMon plugin is installed run the snapmon_config generator
require 'rails_generator'
require 'rails_generator/scripts/generate'

Rails::Generator::Scripts::Generate.new.run(['snapmon_config'])