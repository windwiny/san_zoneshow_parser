#!/usr/bin/env ruby -w

require "pp"
require "open3"

require File.expand_path('../zoneshow.tab.rb', __FILE__)

Dir.chdir File.dirname(__FILE__)



def get_external_ret cmd, str, cmd_type
  t0 = Time.now
  ret, s = Open3.capture2(cmd, :stdin_data=>str, :binmode=>true)
  ret = ret.rstrip.chomp(',')
  puts "**** #{cmd_type} used #{Time.now()-t0} seconds,  exit #{s.exitstatus},  ret #{ret.size} bytes"

  ## puts "# all config, all zone, all alias, Effecctive:", ret.size
  a,b,c,d = {"all config"=>{}}, {"all zone"=>{}}, {"all alias"=>{}}, {}
  if ret =~ /not defined and effect/
    puts
  else
    eval('a,b,c,d = [' + ret + ']')
  end
  [[a,b,c], d]
end

def get_racc_pg_ret str
  px = SANZoneRaccParser.new
  t0 = Time.now
  begin
    defx, effx = px.scan_str(str)
  ensure
  end
  puts "**** ruby rex/racc used #{Time.now()-t0} seconds."
  cfgs, zones, aliass = defx
  defx = [{'all config'=>cfgs}, {'all zone'=>zones}, {'all alias'=>aliass}]
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


str = find_zs_str(ARGV[0] || 'cfg4.txt')
STDERR.puts " FILE=#{ARGV[0] || 'cfg4.txt'}, size: #{str.size}"

defx0, effx0 = get_external_ret('./c_zs', str, 'c flex/bison')

defx1, effx1 = get_racc_pg_ret(str)

t0 = Time.now
defx, effx2 = SANZoneStringManualParser.new.scan_str(str)
puts "**** ruby manual #{Time.now()-t0} seconds."
cfgs, zones, aliass = defx
defx2 = [{'all config'=>cfgs}, {'all zone'=>zones}, {'all alias'=>aliass}]

defx3, effx3 = get_external_ret('./go_zs', str, 'go nex/goyacc')





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

