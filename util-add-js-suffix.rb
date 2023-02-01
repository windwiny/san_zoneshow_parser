#!/usr/bin/env ruby

fslis = %w[
vantlr4/ts2js/TsMainListener-node.js
vantlr4/ts2js/TsMyListenerImpl.js
]
fsvis = %w[
vantlr4/ts2js/TsMainVisitor-node.js
vantlr4/ts2js/TsMyVisitorImpl.js
]

fs = fslis + fsvis
if ARGV.include?('--Listener')
  fs = fslis
elsif ARGV.include?('--Visitor')
  fs = fsvis
end


fs.each do |fn|
  d = File.read(fn)
  r = /(import.*TsMy.*|import.*ts_.is.*)/
  d2 = d.gsub(r) do |xx|
    ss = xx
    if ss.end_with?(".js';")
      ss
    else
      ss.chomp("';") + '.js' + "';"
    end
  end
  p [fn , d.size, d2.size, d2.size-d.size ]
  if [3,9].include?(d2.size-d.size)
    p "update #{fn}"
    File.write(fn, d2)
  else
    p "NOT update #{fn},  same as old and new #{d==d2}"
  end
end
