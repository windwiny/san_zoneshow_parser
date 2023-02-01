#!/usr/bin/env ruby -w

require "pp"
require "open3"
require "tempfile"  # Dir.tmpdir

require File.join(File.absolute_path(__dir__), "zoneshow.tab.rb")


module SANUtil

  # run external cmd
  def self.get_external_ret(cmd, zs_str_or_filename, tips='ex')
    curr_dir = Dir.pwd
    Dir.chdir File.dirname(__FILE__)
    t0 = Time.now
    if (zs_str_or_filename.size < 255) && File.file?(zs_str_or_filename)
      runex = true
    else
      runex = false
    end

    if runex
      ret = %x{#{cmd}  "#{zs_str_or_filename}"} rescue nil
      ret = ret.rstrip.chomp(',')
      puts "**** <#{tips}> \tused #{Time.now()-t0} seconds, \texit #{$?.exitstatus},  ret #{ret.size} bytes" if tips
    else
      ret, s = Open3.capture2(cmd, :stdin_data=>zs_str_or_filename, :binmode=>true)
      ret = ret.rstrip.chomp(',')
      puts "**** <#{tips}> \tused #{Time.now()-t0} seconds, \texit #{s.exitstatus},  ret #{ret.size} bytes" if tips
    end

    ## puts "# all config, all zone, all alias, Effecctive:", ret.size
    if ret =~ /not defined and effect/
      STDERR.puts "not defined and effect"
      a,b,c,d = {"all config"=>{}}, {"all zone"=>{}}, {"all alias"=>{}}, {}
    else
      begin
        eval('a,b,c,d = [' + ret + ']')
      rescue Exception
        fn = File.join(Dir.tmpdir, "zs-get_ext_ret-err-#{Time.now.strftime '%H%M%S'}.log")
        File.binwrite(fn, ret)
        STDERR.puts "  ####  ERROR OUTPUT WRITE TO #{fn}"
        raise
      end
    end
    [[a,b,c], d]
  ensure
    Dir.chdir curr_dir
  end


  # run racc pg
  def self.get_racc_pg_ret(str, cmd_type=nil)
    px = SANZoneRaccParser.new
    t0 = Time.now
    begin
      defx, effx = px.scan_str(str)
    ensure
    end
    puts "**** <ruby rex/racc> \tused #{Time.now()-t0} seconds. \t\tret #{defx.to_s.size} + #{effx.to_s.size} bytes" if cmd_type
    cfgs, zones, aliass = defx
    defx = [{'all config'=>cfgs}, {'all zone'=>zones}, {'all alias'=>aliass}]
    [defx, effx]
  end

  # run ruby manual pg
  def self.get_ruby_manual_pg_ret(str, cmd_type=nil)
    t0 = Time.now
    defx, effx2 = SANZoneStringManualParser.new.scan_str(str)
    puts "**** <ruby manual> \tused #{Time.now()-t0} seconds. \t\tret #{defx.to_s.size} + #{effx2.to_s.size} bytes" if cmd_type
    cfgs, zones, aliass = defx
    defx2 = [{'all config'=>cfgs}, {'all zone'=>zones}, {'all alias'=>aliass}]
    [defx2, effx2]
  end

  # find zoneshow results from sanlog
  def self.find_zs_str(cfgfn)
    zoneshow_s = find_zoneshow_str_from_log(File.binread cfgfn)
    if zoneshow_s.empty?
      puts "empty zoneshow\n\n\n"
      return
    end
    zoneshow_s
  end


  # comare x and y , show diff
  def self.puts_diff(msg, x, y)
    x = {} unless (x && x!={""=>{}})
    y = {} unless (y && y!={""=>{}})
    dif = x==y
    empty = dif && (x=={} || x==[{"all config"=>{}}, {"all zone"=>{}}, {"all alias"=>{}}]) ? 'EMPTY' : ''
    puts " # #{msg}:\t #{dif} #{empty}"
    unless dif
      p ['---- left ---- ', x.to_s.size, left, x.inspect[0..100] ]
      p ['---- right ----', y.to_s.size, right, y.inspect[0..100] ]
      puts
    end
  end

  # run_all_and_compare_result
  def self.run_all_and_compare_result

    zs_str = find_zs_str(ARGV[0] || 'cfg4.txt')
    STDERR.puts " FILE=#{ARGV[0] || 'cfg4.txt'}, size: #{zs_str.size}"

    defx0, effx0 = get_ruby_manual_pg_ret(zs_str, 'ruby manual')

    defx1, effx1 = get_racc_pg_ret(zs_str, 'ruby rex/racc')

    begin
      defx2, effx2 = get_external_ret('./c_zs', zs_str, 'c flex/bison')
    rescue Exception => e
      STDERR.puts e
    end

    begin
      defx3, effx3 = get_external_ret('./go_zs', zs_str, 'go nex/goyacc')
    rescue Exception => e
      STDERR.puts e
    end

    begin
      defx4, effx4 = get_external_ret('java -cp vantlr4:vantlr4/java_vis:antlr-latest-complete.jar  VisitorMain', zs_str, 'java antlr4/visitor')
    rescue Exception => e
      STDERR.puts e
    end

    begin
      defx5, effx5 = get_external_ret('java -cp vantlr4:vantlr4/java_lis:antlr-latest-complete.jar  ListenerMain', zs_str, 'java antlr4/listener')
    rescue Exception => e
      STDERR.puts e
    end

    begin
      defx6, effx6 = get_external_ret('env PYTHONPATH=vantlr4/py3_vis python vantlr4/MainVisitor.py', zs_str, 'python antlr4/visitor')
    rescue Exception => e
      STDERR.puts e
    end

    begin
      defx7, effx7 = get_external_ret('env PYTHONPATH=vantlr4/py3_lis python vantlr4/MainListener.py', zs_str, 'python antlr4/listener')
    rescue Exception => e
      STDERR.puts e
    end

    begin
      defx8, effx8 = get_external_ret('node vantlr4/ts2js/TsMainVisitor-node.js', zs_str, 'ts antlr4/visitor')
    rescue Exception => e
      STDERR.puts e
    end

    begin
      defx9, effx9 = get_external_ret('node vantlr4/ts2js/TsMainListener-node.js', zs_str, 'ts antlr4/listener')
    rescue Exception => e
      STDERR.puts e
    end

    puts

    puts
    puts_diff "diff <ruby/racc> and <ruby/my_parser> defined configuration",    defx1, defx0
    puts_diff "diff <ruby/racc> and <ruby/my_parser> effective configuration",  effx1, effx0

    puts
    if defx0
      puts_diff "diff <ruby/racc> and <c/bison> defined configuration",         defx1, defx2
      puts_diff "diff <ruby/racc> and <c/bison> effective configuration",       effx1, effx2
    else
      puts " ### not get <c/bison>"
    end

    puts
    if defx3
      puts_diff "diff <ruby/racc> and <go/goyacc> defined configuration",       defx1, defx3
      puts_diff "diff <ruby/racc> and <go/goyacc> effective configuration",     effx1, effx3
    else
      puts " ### not get <go/goyacc>"
    end

    puts
    if defx4
      puts_diff "diff <ruby/racc> and <java/antlr4/visitor> defined configuration",    defx1, defx4
      puts_diff "diff <ruby/racc> and <java/antlr4/visitor> effective configuration",  effx1, effx4
    else
      puts " ### not get <java/antlr4/visitor>"
    end

    puts
    if defx5
      puts_diff "diff <ruby/racc> and <java/antlr4/listener> defined configuration",    defx1, defx5
      puts_diff "diff <ruby/racc> and <java/antlr4/listener> effective configuration",  effx1, effx5
    else
      puts " ### not get <java/antlr4/listener>"
    end

    puts
    if defx6
      puts_diff "diff <ruby/racc> and <python/antlr4/visitor> defined configuration",    defx1, defx6
      puts_diff "diff <ruby/racc> and <python/antlr4/visitor> effective configuration",  effx1, effx6
    else
      puts " ### not get  <python/antlr4/visitor>"
    end

    puts
    if defx7
      puts_diff "diff <ruby/racc> and <python/antlr4/listener> defined configuration",    defx1, defx7
      puts_diff "diff <ruby/racc> and <python/antlr4/listener> effective configuration",  effx1, effx7
    else
      puts " ### not get  <python/antlr4/listener>"
    end

    puts
    if defx8
      puts_diff "diff <ruby/racc> and <typscript/antlr4/visitor> defined configuration",    defx1, defx8
      puts_diff "diff <ruby/racc> and <typscript/antlr4/visitor> effective configuration",  effx1, effx8
    else
      puts " ### not get  <typscript/antlr4/visitor>"
    end

    puts
    if defx9
      puts_diff "diff <ruby/racc> and <typscript/antlr4/listener> defined configuration",    defx1, defx9
      puts_diff "diff <ruby/racc> and <typscript/antlr4/listener> effective configuration",  effx1, effx9
    else
      puts " ### not get  <typscript/antlr4/listener>"
    end

    puts

  end

end

if __FILE__ == $0
  SANUtil.run_all_and_compare_result
end

