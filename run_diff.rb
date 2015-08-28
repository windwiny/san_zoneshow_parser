#!/usr/bin/env ruby -w

require "pp"
require "open3"

require File.expand_path('../zoneshow.tab.rb', __FILE__)

Dir.chdir File.dirname(__FILE__)



def get_bison_pg_ret str
  ret = Open3.popen2("./c_zs") {|i,o,t|
    i.print str
    i.close
    o.read
  }

  puts "cfgS, zoneS, aliasS, Effecctive:", ret
  a,b,c,d = 1,2,3,4
  eval('a,b,c,d = [' + ret.chomp(',') + ']')
  [[a,b,c], d]
end

def get_racc_pg_ret str
  px = SANZoneShow.new
  begin
    defx, effx = px.scan_str(str)
  ensure
  end
  [defx, effx]
end


def find_zs_str cfgfn
  zoneshow_s = find_zoneshow_str_from_log(File.binread cfgfn)
  if zoneshow_s.empty?
    puts "empty zoneshow\n\n\n"
    return
  end
  zoneshow_s
end

str = find_zs_str(ARGV[0] || 'cfg4.txt')

defx0, effx0 = get_bison_pg_ret(str)
defx1, effx1 = get_racc_pg_ret(str)
defx2, effx2 = my_zoneshow_parse(str)


cfgs, zones, aliass = defx1
defx1 = [{'cfgS'=>cfgs}, {'zoneS'=>zones}, {'aliasS'=>aliass}]

cfgs, zones, aliass = defx2
defx2 = [{'cfgS'=>cfgs}, {'zoneS'=>zones}, {'aliasS'=>aliass}]

puts "diff c/bison and ruby/racc defined configuration: #{defx0==defx1}"
puts "diff c/bison and ruby/racc effective configuration: #{effx0==effx1}"
puts
puts "diff ruby/racc and ruby/my_parser defined configuration: #{defx1==defx2}"
puts "diff ruby/racc and ruby/my_parser effective configuration: #{effx1==effx2}"
