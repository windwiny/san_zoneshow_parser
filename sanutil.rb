#!/usr/bin/env ruby

require 'csv'
require 'pp'

require File.join(File.absolute_path(__dir__), "zoneshow.tab.rb")
require File.join(File.absolute_path(__dir__), "run_diff.rb")

# extend
module SANUtil

  def self.sanlog2kvs(fn)
    if File.file?(fn)
      zsstr = find_zoneshow_str_from_log(File.binread(fn)).strip
    else
      zsstr = fn
    end
    defx0, effx0 = SANZoneRaccParser.new.scan_str zsstr
    cfgs0, zones0, aliases0 = defx0
    p [ "diff defx0, effx0: ", diff_defx_and_effx(defx0, effx0) ]
    p [ 'all config', cfgs0.keys.size, 'all zone', zones0.keys.size, 'all alias', aliases0.keys.size, 'active cfg', effx0.keys.join(',') ]
    [cfgs0, zones0, aliases0, effx0]
  end

  def self.sanlog2kvsVC(fn)
    if File.file?(fn)
      zsstr = find_zoneshow_str_from_log(File.binread(fn)).strip
    else
      zsstr = fn
    end
    defx1, effx0 = get_external_ret './c_zs', zsstr
    cfgs1, zones1, aliases1 = defx1
    cfgs0, zones0, aliases0 = cfgs1['all config'], zones1['all zone'], aliases1['all alias']
    p [ "diff defx0, effx0: ", diff_defx_and_effx([cfgs0, zones0, aliases0], effx0) ]
    p [ 'all config', cfgs0.keys.size, 'all zone', zones0.keys.size, 'all alias', aliases0.keys.size, 'active cfg', effx0.keys.join(',') ]
    [cfgs0, zones0, aliases0, effx0]
  end

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


  # copy txt from excel, run this method, paste as text to excel
  def self.wwpns_to_alinames(aliases0, csv_txt)
    wwpns = CSV.parse(csv_txt)
    wwpns = wwpns.map{ |e| e[0] ? e[0].split("\n") : [] }
    wwpns.each do |wwpn0|
      alns = wwpn0.map { |wwpn| get_wwpn_aliname_in_aliases(wwpn, aliases0) }
      p alns.join("\n")
    end
  end

  def self.zonecreate(st, ser, cfgn='XXXXXXXX')
    pp st,ser
    zs=[]
    st.product(ser).each do |x,y|
        zs<< "#{x}_#{y}"
        puts %{zonecreate "#{x}_#{y}","#{x};#{y}"}
    end
    puts %{cfgadd "#{cfgn}","#{zs.join ';'}"}
    puts %{\#cfgsave}
    puts %{\#cfgenable #{cfgn}}
  end

end

def assert test, msg = nil
  msg ||= "Failed assertion, no message given."
  unless test then
    msg = msg.call if Proc === msg
    raise msg
  end
  true
end


if __FILE__ != $0
  pp SANUtil.singleton_methods.sort
  nil
end

