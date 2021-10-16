#!/usr/bin/env ruby

require 'csv'

def syntax
  puts "syntax:\n  #{File.basename __FILE__}  1-defined_config_summary.log  san1-01.log san1-02.log ... > s1.csv"
  exit 1
end

if ARGV.size < 2
  syntax
end

f1=ARGV[0]
f2=ARGV[1]

if !File.file?(f1) || !File.file?(f2)
  syntax
end

dd = `awk '/{"all alias"/,/^\\n\\n/' "#{f1}" `

kvs = eval(dd)["all alias"]
$stderr.puts ['alias', kvs.size].join("\t")

def flattan_alias_kvs kvs
  wwpn2alias = {}
  port2alias = {}
  kvs.each do |k, v|
    v.each do |v1|
      if v1.include?(':')
        if wwpn2alias.key? v1
          k2 = wwpn2alias[v1] + ' | ' + k
        else
          k2 = k
        end
        wwpn2alias[v1] = k2
      elsif v1.include?(',')
        if port2alias.key? v1
          k2 = port2alias[v1] + ' | ' + k
        else
          k2 = k
        end
        port2alias[v1] = k2
      else
        p "unknow alias #{v1}"
      end
    end

  end

  [wwpn2alias, port2alias]
end

wwpn2alias, port2alias = flattan_alias_kvs(kvs)
$stderr.puts ['wwpn2alias', wwpn2alias.size, 'port2alias', port2alias.size].join("\t")




$stderr.puts '----------- NPIV parse for portshow/supportshow log ----'
NPIV_WWPN2ALIAS = {}
ARGV[1..-1].each do |fn|
  $stderr.puts ['------ fn', fn].join("\t")
  da = `cat "#{fn}" | awk '/^portId:/,/^Distance:/'`
  id_port = ''

  lls = da.lines
  lls.each do |l|
    sps = l.split
    if sps[0] == 'portId:'
      v1 = sps[1].scan(/../).to_a
      id_port = "#{v1[0].to_i(16)},#{v1[1].to_i(16)}"
      next
    end
    
    if sps.size != 1
      next  # other line
    else
      wwn = sps[0]
    end

    s1 = wwpn2alias[wwn].to_s
    s1 = '[]' if s1==''
    begin
      $stderr.puts "add #{id_port}\t#{wwn} #{s1}"
      NPIV_WWPN2ALIAS[id_port] ||= []
      NPIV_WWPN2ALIAS[id_port] << "#{wwn} #{s1}" # nport
    end
  end
end


$stderr.puts '------ id,port     Speed     Status    WWPN      Alias --------'
ARGV[1..-1].each do |fn|
  $stderr.puts ['------ fn', fn].join("\t")
  # da = `awk '/=======================================/,/^\\w/' "#{fn}"`
  # da = `awk '/^switchshow.*?:\r?$/,/^tempshow.*?:\r?$|\>/' "#{fn}"`
  
  #  switchshow  or  supportshow log
  da = `awk '/^switchName:/{ENTT=1} {if(ENTT>0 && $0~/:\r?$|>/)ENTT=0; if(ENTT>0) { print $0} }'    "#{fn}"`
  # sfn = File.basename(fn).chomp(File.extname(fn))
  sfn = da[0..100].split[1]

  lls = da.lines[1..-2]
  next unless lls

  lls.each do |l|
    ls = l.strip.split(' ', 9)
    next unless /^\s*\d+\s+\d+\s+\w{6}\s+/ =~ l

    id = ls[2][0..1].to_i 16
    po = ls[2][2..3].to_i 16
    idport = "#{id},#{po}"
    speed = ls[4]
    stat = ls[5]=='Online' ? '' : ls[5]
    wwpn = ls[8]
    if /POD license/i =~ wwpn
      wwpn = "#{ls[7]} #{wwpn}"
    end
    s1 = wwpn2alias[wwpn].to_s
    s1 = 'wwpn: '+s1 if s1!=''
    s2 = port2alias[idport].to_s
    s2 = 'port: '+s2 if s2!=''
    s3 = []
    if NPIV_WWPN2ALIAS[idport] && NPIV_WWPN2ALIAS[idport].size > 1
      s3 << NPIV_WWPN2ALIAS[idport]
    end

    s1s2 = [s1,s2].join('  ').rstrip
    s1s2 += "\n" unless s1s2 == ''
    ss = [ sfn, idport, speed, stat,  wwpn, (s1s2 + s3.join("\n")).rstrip ]
    puts ss.to_csv(col_sep: "\t").gsub('""','').rstrip
  end
  puts
end
