#!/usr/bin/env ruby

mat = 'webgui-*/index-*.html'
if ARGV.include?('--Listener')
  mat = 'webgui-*/index-lis.html'
elsif ARGV.include?('--Visitor')
  mat = 'webgui-*/index-vis.html'
end

fs = Dir.glob(mat)

fs.each do |fn|
  d = File.read(fn)
  d2 = d.gsub('type="module" crossorigin src="/assets', 'src="./assets')
  p [fn , d.size, d2.size, d2.size-d.size ]
  if d != d2
    p "update #{fn}"
    File.write(fn, d2)
  else
    p "NOT update #{fn},  old == new"
  end
end
