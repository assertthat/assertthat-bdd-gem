require 'rest-client'
require 'zip'
require 'find'
require 'json'

module AssertThatBDD
  class Features
    def self.download(accessKey: ENV['ASSERTTHAT_ACCESS_KEY'], secretKey: ENV['ASSERTTHAT_ACCESS_KEY'], projectId: nil, outputFolder: './features/', proxy: nil, mode: 'automated', jql: '', jiraServerUrl: nil)
		RestClient.proxy = proxy unless proxy.nil?
		url = 'https://bdd.assertthat.app/rest/api/1/project/'+ projectId +'/features'
		url = jiraServerUrl+"/rest/assertthat/latest/project/"+projectId+"/client/features" unless jiraServerUrl.nil?
		resource = RestClient::Resource.new(url, :user => accessKey, :password => secretKey, :content_type => 'application/zip')
		begin
			contents = resource.get(:accept => 'application/zip', params: {mode: mode, jql: jql})
	    rescue => e
	    	 
	  			if e.respond_to?('response') then
		          if e.response.respond_to?('code') then
		            case e.response.code
		              when 401
		                puts '*** ERROR: Unauthorized error (401). Supplied secretKey/accessKey is invalid'
		              when 400
		                puts '*** ERROR: ' + e.response		          
		              when 500
		                puts '*** ERROR: Jira server error (500)'
		            end
		          end
		        else
		        	puts '*** ERROR: Failed download features: ' + e.message
		        end
				return
		end
		Dir.mkdir("#{outputFolder}") unless File.exists?("#{outputFolder}")
		File.open("#{outputFolder}/features.zip", 'wb') {|f| f.write(contents) }
		features_count = 0
		Zip::File.open("#{outputFolder}/features.zip") do |zip_file|
		  zip_file.each do |entry|
		  	features_count = features_count + 1
			File.delete("#{outputFolder}#{entry.name}") if File.exists?("#{outputFolder}#{entry.name}")
			entry.extract("#{outputFolder}#{entry.name}")
		  end
		end
		puts "*** INFO: #{features_count} features downloaded"
		File.delete("#{outputFolder}/features.zip")
	end
  end
  
  class Report
    def self.upload(accessKey: ENV['ASSERTTHAT_ACCESS_KEY'], secretKey: ENV['ASSERTTHAT_ACCESS_KEY'], projectId: nil, runName: 'Test run '+Time.now.strftime("%d %b %Y %H:%M:%S"), jsonReportFolder: './reports', jsonReportIncludePattern: '.*.json', jiraServerUrl: nil  )
		url = "https://bdd.assertthat.app/rest/api/1/project/" + projectId + "/report"
		url = jiraServerUrl+"/rest/assertthat/latest/project/"+projectId+"/client/report" unless jiraServerUrl.nil?
    	files = Find.find(jsonReportFolder).grep(/#{jsonReportIncludePattern}/)
    	puts "*** INFO: #{files.count} files found matching parretn #{jsonReportIncludePattern}:"
    	puts "*** INFO: #{files}"
    	runId = -1
    	files.each do |f|
			request = RestClient::Request.new(
	         	:method => :post,
	         	:url => url,
	         	:user => accessKey,
	         	:password => secretKey,
	         	:payload => {
		            :multipart => true,
		            :file => File.new(f, 'rb')
	        	},
	        	:headers => { :params =>{:runName => runName, :runId=> runId}}
        	)      
        	begin
	  			response = request.execute 
	  		rescue => e
	  			if e.respond_to?('response') then
		          if e.response.respond_to?('code') then
		            case e.response.code
		              when 401
		                puts '*** ERROR: Unauthorized error (401). Supplied secretKey/accessKey is invalid'
		              when 500
		                puts '*** ERROR: Jira server error (500)'
		            end
		          end
		        else
		        	puts "*** ERROR: Failed to submit json #{f}: " + e.message
		        end
				return
			end
			resposne_json = JSON.parse(response)
			if resposne_json['result'] == 'success'
				runId = resposne_json['runId']
			else
			    puts "*** ERROR: Failed to submit json #{f}: " + resposne_json['message']
			end	
		end
    end
  end  
end
