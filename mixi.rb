require 'rubygems'
# the Watir controller
#require 'watir'
require 'nokogiri'
#require 'firewatir'
#require "watir-webdriver"
require 'safariwatir'

aFile1 = File.new("src", "a+")
aFile2 = File.new("dst", "a+")

# set a variable
#test_site = "http://mixi.jp/list_friend_simple.pl"
#test_site = "http://mixi.jp/list_friend.pl?id=1"
# open a browser
#browser = Watir::Browser.new

id=31031 
while id < 34001
	sleep 1 
	test_site_1="http://mixi.jp/list_friend.pl?id="+id.to_s()
	#puts "Step 1: go to the test site: " + test_site
	browser = Watir::Safari.new 
	browser.goto test_site_1
	value = Nokogiri::HTML.parse(browser.html, nil, 'EUC-JP')
	result_1=value.xpath('//a[starts-with(@href, "list_friend.pl?page=")]')
	if result_1[0] != nil:
		pages=result_1.count()
		real_pages=pages/2
		num_pages=1
		# loop for every pages scrape
		while num_pages < (real_pages+1)
			sleep 1 
			test_site_2 = test_site_1+"&page="+num_pages.to_s()
        		puts test_site_2
        		browser.goto test_site_2
			# for every page lets parse list of friend
			value_2 = Nokogiri::HTML.parse(browser.html, nil, 'EUC-JP')	
			result_2=value_2.xpath('//a[starts-with(@href, "show_friend.pl?id=")]')	
			# get the id number
			i=0
			while i < result_2.length
				doc = Nokogiri::HTML.parse(result_2[i].to_html())
				result_3=doc.search('a').first['href']
				#puts result_3.partition("=")[2]
				friend=result_3.partition("=")[2]
				aFile1.puts(id)
				aFile2.puts(friend)
				i=i+1
			end #end of while 
        		num_pages=num_pages+1
		end #end of while
		#browser.close
		sleep 1 
	else
		puts 'hanya satu halaman' #scrap now!!!
		puts test_site_1 
		value_2 = Nokogiri::HTML.parse(browser.html, nil, 'EUC-JP')
		result_2=value_2.xpath('//a[starts-with(@href, "show_friend.pl?id=")]')
		#get id number
		i=0
		while i< result_2.length
			doc = Nokogiri::HTML.parse(result_2[i].to_html())
			result_3=doc.search('a').first['href']
			#puts result_3.partition("=")[2]
			friend=result_3.partition("=")[2]
			aFile1.puts(id)
			aFile2.puts(friend)
			i=i+1
		end #end of while
	end #end of if
	id=id+1
	sleep 4 
end #end while
browser.close
aFile1.close
aFile2.close
