require 'active_support'
require 'net/http'

class SnapmonSetup
	SERVER = '127.0.0.1:3000'
	
	def initialize
		load_config
		
		begin
			process_config
		rescue Exception => e
			puts "Unable to update SnapMon, invalid config file"
		end
	end
	
	def load_config
		if defined?(RAILS_ROOT)
			file_name = "#{RAILS_ROOT}/config/snapmon.yml"
		else
			file_name = File.join(File.dirname(__FILE__), '../../../../config/snapmon.yml')
		end
		if File.exists?(file_name)
			@config = YAML::load(File.open(file_name).read)
		end
	end
	
	def process_config
		puts "Updating monitoring setup on Snapmon.com"
		resp = http_post("http://#{SERVER}/host_monitors/create_from_config", {:data => @config.to_json, :api => @config['api-key']})
		
		if resp.strip != 'ok'
			puts resp
		end
	end
	
	
	def http_post(url, data)
		res = Net::HTTP.post_form(URI.parse(url), data)
		return res.body
	end	
end

# Call the setup
# SnapmonSetup.new
