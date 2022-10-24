#!/usr/bin/env ruby

require 'csv'
require 'pp'
begin
  require 'pry'
  IRuby::Kernel.instance.switch_backend!(:pry)
rescue
end


require File.join(File.absolute_path(__dir__), "zoneshow.tab.rb")
require File.join(File.absolute_path(__dir__), "run_diff.rb")

# extend
module SANUtil

  # parse san log file using ruby pg
  # return: cfgs0, zones0, aliases0, effx0
  def self.sanlog2kvs(fn)
    if File.file?(fn)
      zsstr = find_zoneshow_str_from_log(File.binread(fn)).strip
    else
      zsstr = fn
    end
    defx0, effx0 = SANZoneRaccParser.new.scan_str zsstr
    cfgs0, zones0, aliases0 = defx0
    puts %{diff defx0, effx0: #{diff_defx_and_effx(defx0, effx0)}}
    porta = aliases0.select { |e| aliases0[e].all? { |e1| e1.include?(':') ? false : true } }
    puts %{ all config: #{cfgs0.keys}\n all zone: #{zones0.keys.size}\n all alias: #{aliases0.keys.size}    alias using port: #{porta.size}\n active cfg: #{effx0.keys.join(',')}}
    [cfgs0, zones0, aliases0, effx0]
  end

  # parse san log file using c pg
  # return: cfgs0, zones0, aliases0, effx0
  def self.sanlog2kvsVC(fn)
    if File.file?(fn)
      zsstr = find_zoneshow_str_from_log(File.binread(fn)).strip
    else
      zsstr = fn
    end
    defx1, effx0 = get_external_ret './c_zs', zsstr, './c_zs'
    cfgs1, zones1, aliases1 = defx1
    cfgs0, zones0, aliases0 = cfgs1['all config'], zones1['all zone'], aliases1['all alias']
    defx0 = [cfgs0, zones0, aliases0]
    puts %{diff defx0, effx0: #{diff_defx_and_effx(defx0, effx0)}}
    porta = aliases0.select { |e| aliases0[e].all? { |e1| e1.include?(':') ? false : true } }
    puts %{ all config: #{cfgs0.keys}\n all zone: #{zones0.keys.size}\n all alias: #{aliases0.keys.size}    alias using port: #{porta.size}\n active cfg: #{effx0.keys.join(',')}}
    [cfgs0, zones0, aliases0, effx0]
  end

  # return ali_names
  def self.get_wwpn_aliname_in_aliases(wwpn, aliases0)
    aliases0 = aliases0['all alias'] if aliases0.has_key?('all alias')
    alins = []
    aliases0.each do |k, ee|
      if ee.include?(wwpn.downcase)
        alins << k
      end
    end
    if alins.size > 0
      return alins.join(',')
    else
      return nil
    end
  end


  # input: copy txt from excel, run this method, 
  # output: paste as text to excel
  def self.wwpns_to_alinames(aliases0, csv_txt)
    wwpns = CSV.parse(csv_txt)
    wwpns = wwpns.map{ |e| e[0] ? e[0].split("\n") : [] }
    wwpns.each do |wwpn0|
      alns = wwpn0.map { |wwpn| get_wwpn_aliname_in_aliases(wwpn, aliases0) }
      p alns.join("\n")
    end
  end

  # input: storage arry ,  server array
  # output: zonecreate, cfgadd script snippets
  def self.zonecreate(st, ser, cfgn='XXXXXXXX')
    pp st,ser
    zs=[]
    st.product(ser).each do |x,y|
        zs<< "#{x}_#{y}"
        puts %{zonecreate "#{x}_#{y}","#{x};#{y}" ;}
    end
    puts %{cfgadd "#{cfgn}","#{zs.join ';'}"}
    puts %{\#cfgsave}
    puts %{\#cfgenable #{cfgn}}
  end

end


# assert condition
def assert test, msg = nil
  msg ||= "Failed assertion, no message given."
  unless test then
    msg = msg.call if Proc === msg
    raise msg
  end
  true
end

__DOC__ = <<~'EOS'
 most common methods:
   cfgs0, zones0, aliases0, effx0 = SANUtil.sanlog2kvs(fn); nil  #-->  [Hash,Hash,Hash,Hash]
   SANUtil.wwpns_to_alinames(aliases0, csv_txt)   # -->   csv wwpns
   SANUtil.get_wwpn_aliname_in_aliases(wwpn, aliases0)   #--> 

EOS

if __FILE__ != $0
  SANUtil.singleton_methods.sort.each do |e|
    puts "show-source -d SANUtil.#{e}"
  end
  puts
  puts __DOC__
  puts
  nil
end

