#!/usr/bin/env ruby

# remove html <script> attr type=module and crossorigin, use ./assets relative path,
# for offline used. open file:///xxx.html

fsl = ['webgui-lis-release/index-lis.html']
fsv = ['webgui-vis-release/index-vis.html']
if ARGV.size == 0
  fs = fsl + fsv
elsif ARGV.include?('--Listener')
  fs = fsl
elsif ARGV.include?('--Visitor')
  fs = fsv
else
  fs = ARGV.map { |mat| Dir.glob(mat) }.flatten.select { |fn| fn=~/\.html$/i }
end

p fs

fs.each do |fn|
  d = File.read(fn)
  d2 = d.gsub('type="module" crossorigin src="/assets', 'src="./assets')
  if d != d2
    puts " update #{fn}, #{d2.size}-#{d.size}=#{d2.size-d.size}"
    File.write(fn, d2)
  else
    puts " NOT update #{fn}, #{d.size} bytes.  old == new"
  end
end
