require 'net/http'
require 'uri'
require 'active_support'


class SnapmonConfigGenerator < Rails::Generator::Base
	SERVER = '127.0.0.1:3000'
	
	attr_accessor :contacts, :contacts_to_use, :api_key, :domain
	
	def bold(text)
		"\033[1m#{text}\033[22m"
	end
	
	def run_console
		puts bold("*** SnapMon Plugin Installed, now setting up your config file ***")
		puts "You will be asked a series of questions to setup application monitoring\n"

		load_api_key

		load_domain
		
		load_contacts
	end
	
	def load_api_key
		puts bold("Do you have a Snapmon Account?")
		print "[Y/n]: "
		
		has_account = !['n', 'no', 'false'].include?(STDIN.gets.strip.downcase)
		
		if !has_account
			puts ""
			puts "First you should sign up for a Snapmon account at http://www.snapmon.com/"
			puts "Once you have signed up, press enter to resume"
			STDIN.gets
			
			# recurse
			load_api_key
		end
		
		puts ""
		puts "Enter your login e-mail and password: "
		puts "Email: "
		email = STDIN.gets.strip
		puts "Password:"
		# Disable echo for password input
		begin ; system "stty -echo" ; rescue ; end

		# read password
		password = STDIN.gets.strip

		# re-enable password
		begin ; system "stty echo" ; rescue ; end
		
		resp = http_get("http://#{SERVER}/users/fetch_api_key/?email=#{email}&password=#{password}")
		
		data = ActiveSupport::JSON.decode(resp)
		
		if data['error'] || !data['api_key']
			puts data['error'] || 'An error occurred'
			
			load_api_key
		else
			self.api_key = data['api_key']
			puts "\nAPI Key has been loaded\n"
		end
	end
	
	def load_domain
		puts ""
		puts "What is the domain for this site? (example: www.google.com)"
		
		self.domain = STDIN.gets.strip
		
		if self.domain.blank? || self.domain[/\//]
			puts ""
			puts "#{self.domain} is not valid, please use the following format: www.google.com"
			load_domain
		end
	end
	
	def load_contacts
		get_contact_names
		
		puts ""
		puts bold("Please choose who to notify if this app goes down")
		
		self.contacts.each_with_index do |contact,i|
			puts "#{i+1}) #{contact['name']}"
		end
		
		puts "Choose by number, seperate with commas (ex:  1,4)"
		puts "Or type 'new' to add a new contact"
		
		contact_ids = STDIN.gets.strip
		
		if contact_ids == 'new'
			new_contact
			return
		end
		
		self.contacts_to_use = []
		contact_ids.split(/[ ]*,[ ]*/).each do |contact_id|
			contact = self.contacts[contact_id.to_i-1]
			self.contacts_to_use << {:name => contact['name'], :email => !contact['email'].blank?, :sms => !contact['sms_number'].blank?, :aim => !contact['aim'].blank?, :gtalk => !contact['gtalk'].blank?}
		end
		
	end
	
	def new_contact
		puts ""
		puts "Contacts are shared between monitors and are notified when a host goes down"
		
		name = nil
		loop do
			puts "Enter the name of the contact: "
			name = STDIN.gets.strip
			
			if name.blank?
				puts "You must enter a contacts name"
				puts ""
			else
				break
			end
		end
		
		puts ""
		puts "Enter #{name}'s e-mail (or blank)"
		email = STDIN.gets.strip
		
		puts ""
		puts "Enter #{name}'s SMS Number (or blank)"
		sms_number = STDIN.gets.strip
		
		puts ""
		puts "Enter #{name}'s AIM (or blank)"
		aim = STDIN.gets.strip
		
		puts ""
		puts "Enter #{name}'s Google Talk (or blank)"
		gtalk = STDIN.gets.strip
		
		result = http_post("http://#{SERVER}/contacts.js", {:api => self.api_key, 'config' => '1', 'contact[name]' => name, 'contact[email]' => email, 'contact[sms_number]' => sms_number, 'contact[aim]' => aim, 'contact[gtalk]' => gtalk})
		
		if result.strip != 'ok'
			data = ActiveSupport::JSON.decode(result)
			
			puts bold("Contact could not be saved because of the following:")
			data.each do |e| 
				puts e[0].capitalize.gsub('_', ' ') + ' ' + e[1]
			end
		end
		
		load_contacts
	end
	
	def get_contact_names
		resp = http_get("http://#{SERVER}/contacts.js?api=#{self.api_key}")
		
		self.contacts = ActiveSupport::JSON.decode(resp)
	end

	
	def http_get(url_str)
		url = URI.parse(url_str)
		req = Net::HTTP::Get.new(url.request_uri)
		res = Net::HTTP.start(url.host, url.port) {|http|
			http.request(req)
		}
		return res.body
	end
	
	def http_post(url, data)
		res = Net::HTTP.post_form(URI.parse(url), data)
		return res.body
	end
	
	
  def manifest
		run_console()
		
		puts "Your site will now begin being tracked once it is published in production.  Your configuration file has been setup in config/snapmon.yml, you can make further changes from there.  "
		
    record do |m|
      # m.directory "config"
      m.template 'snapmon.yml', "config/snapmon.yml"
    end
  end
end
