#!/usr/bin/env ruby
require 'roo'

Dir.glob("**/*.xlsx") do |file|
  xlsx = Roo::Spreadsheet.open(file)
  chapter = ""
  bookname = xlsx.column(1)
  book_name = bookname[1]
  verse = ""
  book = {}
  chapter = {}
  verses = {}
  html_tag=""


  check_chapter = ""
  xlsx.each_with_pagename do |name, sheet|
    sheet.each(book: "Book", chapter: "Chapter", verse: "Verse" , notes: "TRANSLATION" )  do |s|
      if s[:chapter] != "Chapter"
        verse = s[:verse].split("-")[0]
        if(check_chapter != s[:chapter])
          verses = {}
          check_chapter = s[:chapter]

          verses[verse] = s[:notes]
          chapter[s[:chapter]] = verses
          

        elsif(check_chapter == s[:chapter])
          verses[verse] = s[:notes]
        end
      end
    end
  end
  html_tag += "<#{book_name}>"
  output   = File.open("#{book_name}", 'a')
  chapter.each do |chapter_v, v|

      verse_m = chapter[chapter_v]
      html_tag+= "<#{chapter_v}>"
      verse_m.each do |verse, v|        
       
        html_tag+= "<#{File.basename(verse.partition('-').first, '.*')}>"
        
        p_tn_data = verse_m[verse].split(/\R+/)
        split_bullet = p_tn_data.join('').split(/(?=•)/) 

        iterate_split_bullet = split_bullet.each
        iterate_split_bullet.next

        loop do
          begin
            final_data = iterate_split_bullet.next
            before_hyphan = final_data.partition('-').first.partition('•').last # It will show only string which is before hyphan.
            after_hyphan  = final_data.partition('-').last # It will show only string which is after hyphan.
            # Need to add here logic so that obly require varse should go in file. 
             html_tag+="#{before_hyphan}"
             html_tag+= "#{after_hyphan}"
            # output << "#"+"#{before_hyphan}\n\n"
            # output << "#{after_hyphan} \n"
          rescue StopIteration
            break
          end
        end
        html_tag+= "</#{File.basename(verse.partition('-').first, '.*')}>"                
        output << html_tag
        html_tag = ""
    end
    html_tag += "</#{chapter_v}>"
  end
  html_tag+="</#{book_name}>"
  output << html_tag
  output.close
  html_tag=""
end



