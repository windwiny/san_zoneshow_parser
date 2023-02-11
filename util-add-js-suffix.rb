#!/usr/bin/env ruby


# tsc compile .ts to .js, import statement missing .js
# add .js suffix

fslis = %w[
vantlr4/ts2js/TsMainListener-node.js
vantlr4/ts2js/TsMyListenerImpl.js
]
fsvis = %w[
vantlr4/ts2js/TsMainVisitor-node.js
vantlr4/ts2js/TsMyVisitorImpl.js
]

if ARGV.size == 0
  fs = fslis + fsvis
elsif ARGV.include?('--Listener')
  fs = fslis
elsif ARGV.include?('--Visitor')
  fs = fsvis
else
  fs = ARGV.map { |mat| Dir.glob(mat) }.flatten.select { |fn| fn=~/\.js$/ }
end

p fs

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
  if [3,9].include?(d2.size-d.size)
    puts " update #{fn}, #{d2.size}-#{d.size}=#{d2.size-d.size}"
    File.write(fn, d2)
  else
    puts " NOT update #{fn}, #{d2.size}-#{d.size}=#{d2.size-d.size}. old #{d==d2 ? '==' : '!=' } now"
  end
end
