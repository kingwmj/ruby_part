require "open-uri"

def output_root_dir(p,file)
	f=File.open(file,"w")
	1.upto(p) do |i|
		f.puts "http://www.169pp.com/info/4_#{i}.htm"
	end
end

def read_dir_first_page(file1,file2)
	root="http://www.169pp.com"
	f2=File.open(file2,"a")
	x=[]
	#puts file1
	File.open(file1,"r").each do |line|
		http=open(line.chomp!)
		str=http.read
		str.encoding
		list=str.scan(/a\s+href\=(\/News\/\d+\-\d+\-\d+\/\d+\.htm)\s+title/)
		list.each do |i|
			i.each do |b|
				b=root+b
				#puts b
				x<<b
			end
		end
		#p str
		x.uniq!
		x.each do |i|
			f2.puts i
		end
	end
end

def get_fig_url(file3,file2)
	f2=File.open(file2,"r")
	f3=File.open(file3,"a")
	f2.each do |url|
		list=[]
		http=open(url)
		str=http.read
		str.encoding
		list=str.scan(/img\s+src\=(http:\/\/\S+?\.jpg)\>/)
		list.each do |i|
			f3.puts i
		end
	end
end

def download_single(lines,i)
	filename=""
	0.upto(lines.size) do |l|
		if l % 5 == i
			if lines[l]=~/\/(\w+?\/\w+?\/\w+?\.jpg)/
				filename=$1
				filename.gsub!("\/","")
				next if File.exist?(filename)
				puts filename
			end

			open(lines[l]) do |fin|
				open(filename,"wb") do |fout|
					fout.write fin.read
					fout.flush
				end
			end
		end
	end
end
	
def download_threads(file)
	lines=File.open(file).readlines
	threads=[]
	5.times do |i|
		thread=Thread.new do
			download_single(lines,i)
			puts i
		end
		threads << thread
	end
	threads.each {|thread|thread.join}
end

def main
	page_t=20;
	file1="total_page.txt";
	file2="total_first_page.txt";
	file3="fig_urls.txt";
	#output_root_dir(page_t,file1)
	#read_dir_first_page(file1,file2)
	#get_fig_url(file3,file2)
	download_threads(file3)
end

main
#output_root_dir(20,"total_page.txt")
#read_dir_first_page("http://www.169pp.com/info/4_1.htm","test1.txt")
#get_fig_url("http://www.169pp.com/News/2015-03-13/574993.htm","test2.txt")
#download_single("http://724.169pp.net/169mm/201503/061/21.jpg")
#download_threads("test2.txt")



=begin
#下载文件可以用以下代码
File.open('/home/user/1.jpg', 'wb') {|f| 
	f.write(open('http://tp1.sinaimg.cn/2264073420/180/40025028927/1') {|f1| 
	f1.read})
}
=end
