#!/usr/bin/env ruby -w

require "pp"
require "open3"

require File.expand_path('../zoneshow.tab.rb', __FILE__)

Dir.chdir File.dirname(__FILE__)



def get_bison_pg_ret str
  ret = Open3.popen2e("./c_zs") {|i,o,t|
    i.print str
    i.close
    o.read
  }

  puts "# all config, all zone, all alias, Effecctive:", ret.rstrip.chomp(',')
  a,b,c,d = {"all config"=>{}}, {"all zone"=>{}}, {"all alias"=>{}}, {}
  if ret =~ /not defined and effect/
    puts
  else
    eval('a,b,c,d = [' + ret.rstrip.chomp(',') + ']')
  end
  [[a,b,c], d]
end

def get_racc_pg_ret str
  px = SANZoneRaccParser.new
  begin
    defx, effx = px.scan_str(str)
  ensure
  end
  [defx, effx]
end

def find_zs_str cfgfn
  zoneshow_s = Utils.find_zoneshow_str_from_log(File.binread cfgfn)
  if zoneshow_s.empty?
    puts "empty zoneshow\n\n\n"
    return
  end
  zoneshow_s
end

def get_goyacc_pg_ret str
  ret = Open3.popen2e("./go_zs") {|i,o,t|
    i.print str
    i.close
    o.read
  }

  puts "# all config, all zone, all alias, Effecctive:", ret.rstrip.chomp(',')
  a,b,c,d = {"all config"=>{}}, {"all zone"=>{}}, {"all alias"=>{}}, {}
  if ret =~ /not defined and effect/
    puts
  else
    eval('a,b,c,d = [' + ret.rstrip.chomp(',') + ']')
  end
  [[a,b,c], d]
end


str = find_zs_str(ARGV[0] || 'cfg4.txt')

defx0, effx0 = get_bison_pg_ret(str)
defx1, effx1 = get_racc_pg_ret(str)
defx2, effx2 = SANZoneStringManualParser.new.scan_str(str)
defx3, effx3 = get_goyacc_pg_ret(str)


cfgs, zones, aliass = defx1
defx1 = [{'all config'=>cfgs}, {'all zone'=>zones}, {'all alias'=>aliass}]

cfgs, zones, aliass = defx2
defx2 = [{'all config'=>cfgs}, {'all zone'=>zones}, {'all alias'=>aliass}]


def puts_diff(msg, x, y)
  dif = x==y
  puts " # #{msg}: #{dif}"
  unless dif
    p '-------- left -----'
    puts x
    p '-------- right -----'
    puts y
    puts
  end
end
puts
puts_diff "diff c/bison and ruby/racc defined configuration",           defx0, defx1
puts_diff "diff c/bison and ruby/racc effective configuration",         effx0, effx1
puts_diff "diff ruby/racc and ruby/my_parser defined configuration",    defx1, defx2
puts_diff "diff ruby/racc and ruby/my_parser effective configuration",  effx1, effx2
puts_diff "diff ruby/racc and go/goyacc defined configuration",    defx1, defx3
puts_diff "diff ruby/racc and go/goyacc effective configuration",  effx1, effx3

