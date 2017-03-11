#!/usr/bin/env ruby

html_tag = ""
tmp = ""
no_dir_temp = ""
temp = ""
Dir.glob('*').each do |dir|
	if File.directory?(dir)
		html_tag += "<#{dir}>"
			files = Dir["#{dir}/**/*"]
			if(files.size > 0)
				files.each do |file_name|
					if File.directory? file_name
						tmp = file_name.split("/")[1]
						if(file_name.split("/")[2] == nil)
							html_tag += "<#{tmp}>"
						else
							html_tag += "</#{no_dir_temp}>" if temp != ""
							no_dir_temp = file_name.split("/")[2]
							temp = no_dir_temp
							html_tag += "<#{no_dir_temp}>"
						end
					else
						File.open(file_name) do |file|
						html_tag += "<#{File.basename(file_name, ".md")}>" 
					      file.each_line do |line|
					      	html_tag += line
					      end
					    html_tag += "</#{File.basename(file_name, ".md")}>"  
					    end
					end
				end

			end
			
		html_tag+= "</#{no_dir_temp}>"
		html_tag += "</#{tmp}>"
		html_tag += "</#{dir}>"

		output   = File.open("#{dir}.txt", 'w')
		output << html_tag
		output.close
		html_tag = ""
		temp = ""
		no_dir_temp = ""
	end	 
end
