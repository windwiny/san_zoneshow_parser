#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.6.0
# from Racc grammar file "".
#

require 'racc/parser.rb'

require "pp"
require "shellwords"
require 'fileutils'
require File.join(File.absolute_path(__dir__), "zoneshow.rex.rb")

class SANZoneRaccParser < Racc::Parser

module_eval(<<'...end zoneshow.racc/module_eval...', 'zoneshow.racc', 80)
  def on_error *rr
    puts "---- on_error   lineno:#{@lineno}"
    super
  end

...end zoneshow.racc/module_eval...
##### State transition tables begin ###

racc_action_table = [
    32,     3,    32,    33,    34,    33,    34,    39,    40,    47,
    48,    39,    40,     4,     6,     7,     9,    10,    11,    14,
    15,    16,    19,    20,    23,    24,    26,    28,    29,    35,
    36,    41,    42,    44 ]

racc_action_check = [
    24,     0,    41,    24,    24,    41,    41,    29,    29,    43,
    43,    44,    44,     1,     2,     3,     4,     6,     7,     8,
    10,    11,    12,    14,    17,    19,    20,    21,    23,    25,
    28,    30,    35,    37 ]

racc_action_pointer = [
    -1,    13,    10,    12,    16,   nil,    11,    14,    13,   nil,
    13,    16,    13,   nil,    16,   nil,   nil,    12,   nil,    18,
    19,    18,   nil,    21,    -7,    21,   nil,   nil,    23,    -3,
    23,   nil,   nil,   nil,   nil,    25,   nil,    25,   nil,   nil,
   nil,    -5,   nil,    -1,     1,   nil,   nil,   nil,   nil,   nil ]

racc_action_default = [
   -34,   -34,   -34,    -6,   -34,    -1,   -34,   -34,   -11,    50,
   -34,   -34,   -20,    -5,   -34,   -28,    -2,    -3,   -10,   -34,
   -34,    -4,   -19,   -34,   -15,    -7,    -9,   -27,   -34,   -24,
   -12,   -14,   -16,   -17,   -18,   -34,   -31,   -21,   -23,   -25,
   -26,   -34,    -8,   -29,   -34,   -13,   -30,   -32,   -33,   -22 ]

racc_goto_table = [
    31,    38,     1,     2,     5,     8,    12,    17,    21,    13,
    25,    18,    30,    22,    37,    27,    49,    45,    43,    46 ]

racc_goto_check = [
    12,    15,     1,     2,     3,     4,     5,     6,     7,     8,
     9,    10,    11,    13,    14,    16,    15,    12,    17,    18 ]

racc_goto_pointer = [
   nil,     2,     3,     2,     2,    -2,    -5,    -7,     1,   -10,
    -1,   -12,   -24,    -4,   -15,   -28,    -6,   -18,   -24 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  2, 14, :_reduce_1,
  4, 14, :_reduce_2,
  4, 15, :_reduce_3,
  4, 16, :_reduce_4,
  2, 17, :_reduce_5,
  0, 17, :_reduce_6,
  3, 21, :_reduce_7,
  3, 22, :_reduce_8,
  1, 22, :_reduce_9,
  2, 18, :_reduce_10,
  0, 18, :_reduce_11,
  3, 23, :_reduce_12,
  3, 24, :_reduce_13,
  1, 24, :_reduce_14,
  0, 24, :_reduce_15,
  1, 25, :_reduce_none,
  1, 25, :_reduce_none,
  1, 25, :_reduce_none,
  2, 19, :_reduce_19,
  0, 19, :_reduce_20,
  3, 26, :_reduce_21,
  3, 27, :_reduce_22,
  1, 27, :_reduce_23,
  0, 27, :_reduce_24,
  1, 28, :_reduce_none,
  1, 28, :_reduce_none,
  2, 20, :_reduce_27,
  0, 20, :_reduce_28,
  3, 29, :_reduce_29,
  2, 30, :_reduce_30,
  0, 30, :_reduce_31,
  1, 31, :_reduce_none,
  1, 31, :_reduce_none ]

racc_reduce_n = 34

racc_shift_n = 50

racc_token_table = {
  false => 0,
  :error => 1,
  :DEFINED => 2,
  :NODEFINED => 3,
  :EFFECTIVE => 4,
  :NOEFFECTIVE => 5,
  :CFG => 6,
  :NAME => 7,
  ";" => 8,
  :ZONE => 9,
  :PORT => 10,
  :WWPN => 11,
  :ALIAS => 12 }

racc_nt_base = 13

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "DEFINED",
  "NODEFINED",
  "EFFECTIVE",
  "NOEFFECTIVE",
  "CFG",
  "NAME",
  "\";\"",
  "ZONE",
  "PORT",
  "WWPN",
  "ALIAS",
  "$start",
  "zoneshow",
  "defx",
  "effx",
  "cfgs",
  "zones",
  "aliass",
  "ezones",
  "cfg",
  "zns",
  "zone",
  "ans",
  "an",
  "alias",
  "aps",
  "ap",
  "ezone",
  "ports",
  "port" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'zoneshow.racc', 6)
  def _reduce_1(val, _values, result)
     result = val
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 7)
  def _reduce_2(val, _values, result)
     STDERR.puts " !! not defined and effect"; result = [[{},{},{}], {}]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 10)
  def _reduce_3(val, _values, result)
     result = [val[1].freeze, val[2].freeze, val[3].freeze]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 13)
  def _reduce_4(val, _values, result)
     result = { val[2] => val[3].freeze }
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 16)
  def _reduce_5(val, _values, result)
     result = val[0].merge(val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 17)
  def _reduce_6(val, _values, result)
     result = {}
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 20)
  def _reduce_7(val, _values, result)
     result = { val[1] => val[2] }
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 23)
  def _reduce_8(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 24)
  def _reduce_9(val, _values, result)
     result = [val[0]]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 28)
  def _reduce_10(val, _values, result)
     result = val[0].merge(val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 29)
  def _reduce_11(val, _values, result)
     result = {}
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 32)
  def _reduce_12(val, _values, result)
     result = { val[1] => val[2] }
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 35)
  def _reduce_13(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 36)
  def _reduce_14(val, _values, result)
     result = [val[0]]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 37)
  def _reduce_15(val, _values, result)
     result = []
    result
  end
.,.,

# reduce 16 omitted

# reduce 17 omitted

# reduce 18 omitted

module_eval(<<'.,.,', 'zoneshow.racc', 45)
  def _reduce_19(val, _values, result)
     result = val[0].merge(val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 46)
  def _reduce_20(val, _values, result)
     result = {}
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 49)
  def _reduce_21(val, _values, result)
     result = { val[1] => val[2] }
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 52)
  def _reduce_22(val, _values, result)
     result = val[0] << val[2]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 53)
  def _reduce_23(val, _values, result)
     result = [val[0]]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 54)
  def _reduce_24(val, _values, result)
     result = []
    result
  end
.,.,

# reduce 25 omitted

# reduce 26 omitted

module_eval(<<'.,.,', 'zoneshow.racc', 61)
  def _reduce_27(val, _values, result)
     result = val[0].merge(val[1])
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 62)
  def _reduce_28(val, _values, result)
     result = {}
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 65)
  def _reduce_29(val, _values, result)
     result = { val[1] => val[2] }
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 68)
  def _reduce_30(val, _values, result)
     result = val[0] << val[1]
    result
  end
.,.,

module_eval(<<'.,.,', 'zoneshow.racc', 69)
  def _reduce_31(val, _values, result)
     result = []
    result
  end
.,.,

# reduce 32 omitted

# reduce 33 omitted

def _reduce_none(val, _values, result)
  val[0]
end

end   # class SANZoneRaccParser


class SANZoneStringManualParser
  def _definedcfg2defx(all)
    if all.lstrip.start_with? 'no configuration defined'
      return [{}, {}, {}]
    end
    cfg_str, other = all.split('zone:', 2)
    zone_str, ali_str = other.split('alias:', 2)

    cfgs=cfg_str.split('cfg:').map do |s|
      s.gsub(";",' ').shellsplit
    end
    cfgs.delete([])
    cfgh = {}
    cfgs.each do |cfg|
      cfgh[cfg[0]] = cfg[1..-1]
    end

    as = {}
    ali_str.to_s.split("alias:").map do |s|
      ss = s.gsub(";",' ').shellsplit
      as[ss[0]] = ss[1..-1]
    end

    zs = {}
    zone_str.split("zone:").each do |s|
      ss = s.gsub(";",' ').shellsplit
      zs[ss[0]] = ss[1..-1]
    end

    [cfgh, zs, as]
  end

  def _effectivecfg2effx(all)
    if all.lstrip.start_with? 'no configuration in effect'
      return({})
    end
    cfg_str, zone_str = all.split('zone:', 2)

    cfgs=cfg_str.split('cfg:')
    STDERR.puts "Error: effective config size > 1. #{cfg_str}" unless cfgs.size == 2 && cfgs[0].strip == ''
    cfg_name = cfgs[1].strip

    zs = {}
    zone_str.split('zone:').each do |s|
      ss = s.shellsplit
      zs[ss[0]] = ss[1..-1]
    end
    {cfg_name => zs}
  end

  def scan_str(str)
    defcfg, effcfg = str.sub(/^\s*Defined configuration:/, '').split(/^\s*Effective configuration:/)
    defx2 = _definedcfg2defx(defcfg)
    effx2 = _effectivecfg2effx(effcfg)
    [defx2, effx2]
  end
end


module SANUtil
  def self.find_zoneshow_str_from_log(str)
    begin_pos = str.rindex(/^\s*Defined configuration:/)
    return ('') unless begin_pos
    end_pos = str.index(/^.+\>|^\s*{/, begin_pos) || 0
    str[begin_pos..end_pos-1]
  end

  def self.diff_defx_and_effx(defx1, effx1)
    res = defx_split_and_expand_ports(defx1)
    eff_name = effx1.keys[0]
    effx1[eff_name] == res[eff_name]
  end

  def self.generate_effictive_create_script_from_effx(effx1)
    str_s = []
    effx1 = $keeporder ? effx1.to_a : effx1.to_a.sort
    effx1.each do |k2, v2|
      _v2 = $keeporder ? v2.to_a : v2.to_a.sort
      _v2.each do |k, v|
        vs = v.join(';')
        STDERR.puts 'Error: zone join have " ' if vs.include?('"')
        str_s << %{ zonecreate "#{k}","#{vs}"}
      end

      str_s << ''
      vs = v2.keys.join(';')
      STDERR.puts 'Error: cfg join have " ' if vs.include?('"')

      str_s << %{cfgcreate "#{k2}","xxx"}
      _ks = $keeporder ? v2.keys.to_a : v2.keys.to_a.sort
      _ks.each { |zn| str_s << %{ cfgadd "#{k2}","#{zn}"} }
      str_s << %{cfgremove "#{k2}","xxx"}
    end
    str_s << ''
    str_s << ' # cfgsave'
    str_s
  end

  def self.defx_split_and_expand_ports(defx1)
    cfgs, zones, aliass = defx1

    res = {}
    cfgs = $keeporder ? cfgs.to_a : cfgs.to_a.sort
    cfgs.each do |cfgname, zns|
      res[cfgname] = z_ = {}
      zns.each do |zn|
        z_[zn] = v_ = []
        zones.fetch(zn).each do |pOwOn|
          # FIXME TODO
          v_.concat(/^\d+,\d+$|^\w{2}(:\w{2}){7}$/ =~ pOwOn ? [pOwOn] : aliass.fetch(pOwOn))
        end
      end
    end
    res
  end

  def self.remove_not_effactive_cfg(defx1, keeped_cfgname)
    cfgs, zones, aliass = defx1

    cfgs_a, zones_a, aliass_a = if $keeporder
      [cfgs.to_a, zones.to_a, aliass.to_a]
    else
      [cfgs.to_a.sort, zones.to_a.sort, aliass.to_a.sort]
    end

    res = []
    usedzns = usedalias = nil
    cfgs_a.each do |cfgname, zns|
      if cfgname == keeped_cfgname
        usedzns = zns.to_a
        usedzns = usedzns.sort unless $keeporder
        usedalias = usedzns.map { |zn| zones.fetch(zn) }.flatten.uniq
        usedalias = usedalias.sort unless $keeporder
      else
        res << %Q{cfgdelete "#{cfgname}"}
      end
    end

    res << ''
    zones_a.each do |znn, znv|
      res << %{zonedelete "#{znn}"} unless usedzns.include?(znn)
    end

    res << ''
    aliass_a.each do |alin, aliv|
      res << %{alidelete "#{alin}"} unless usedalias.include?(alin)
    end

    res
  end

  def self.generate_split_cfg_create_script_from_defx(defx1)
    cfgs, zones, aliass = defx1
    rvs = {}
    cfgs_a = $keeporder ? cfgs.to_a : cfgs.to_a.sort
    cfgs_a.each do |cfgname, zns|
      rvs[cfgname] = str_s = []
      usedzns = zns.to_a
      usedzns = usedzns.sort unless $keeporder
      usedalias = usedzns.map { |zn| zones.fetch(zn) }.flatten.uniq
      usedalias = usedalias.sort unless $keeporder

      str_s << "-- #{cfgname}"
      usedalias.each do |ali|
        if v=aliass[ali]
          str_s << %Q{ alicreate "#{ali}","#{v.join ';'}"}
        else
          STDERR.puts "??" unless /^\d+,\d+$|^\w{2}(:\w{2}){7}$/ =~ ali # FIXME mulit value in alias
        end
      end
      str_s << ''
      usedzns.each do |zn|
        v = zones.fetch(zn)
        str_s << %Q{ zonecreate "#{zn}","#{v.join ';'}"}
      end

      str_s << ''
      str_s << %Q{cfgcreate "#{cfgname}","xxx"}
      usedzns.each do |zn|
        str_s << %Q{ cfgadd "#{cfgname}","#{zn}"}
      end
      str_s << %Q{cfgremove "#{cfgname}","xxx"}
      str_s << " # cfgsave"
      str_s << ''
    end

    rvs
  end

  def self.generate_all_create_script_from_defx(defx1)
    cfgs, zones, aliass = defx1

    cfgs_a, zones_a, aliass_a = if $keeporder
      [cfgs.to_a, zones.to_a, aliass.to_a]
    else
      [cfgs.to_a.sort, zones.to_a.sort, aliass.to_a.sort]
    end

    str_s = []
    aliass_a.each do |k, v|
      vs = v.join(';')
      STDERR.puts 'Error: alias join have " ' if vs.include?('"')
      str_s << %{ alicreate "#{k}","#{vs}"}
    end

    str_s << ''
    zones_a.each do |k, v|
      vs = v.join(';')
      STDERR.puts 'Error: zone join have " ' if vs.include?('"')
      str_s << %{ zonecreate "#{k}","#{vs}"}
    end

    str_s << ''
    cfgs_a.each do |k, v|
      vs = v.join(';')
      STDERR.puts 'Error: cfg join have " ' if vs.include?('"')
      str_s << %{cfgcreate "#{k}","xxx"}
      _vv = $keeporder ? v.to_a : v.to_a.sort
      _vv.each { |zn| str_s << %{ cfgadd "#{k}","#{zn}"} }
      str_s << %{cfgremove "#{k}","xxx"}
    end
    str_s << ''
    str_s << ' # cfgsave'

    str_s
  end


  def self.parse_file(fn)
    bd = File.directory?("/tmp") ? "/tmp/ttt2" : "c:"
    tmpdir = "#{bd}/sanlog-#{File.basename(fn).chomp(File.extname fn)}-#{Time.now.strftime '%H%M%S'}"
    FileUtils.mkdir_p(tmpdir) unless File.directory?(tmpdir)

    zoneshow_s = find_zoneshow_str_from_log(File.binread fn)
    if zoneshow_s.empty?
      STDERR.puts "empty zoneshow\n\n\n"
      return
    end

    defx1, effx1 = SANZoneRaccParser.new.scan_str(zoneshow_s)
    defx2, effx2 = SANZoneStringManualParser.new.scan_str(zoneshow_s)
    dif1, dif2 = [defx1 == defx2, effx1 == effx2]

    File.open("#{tmpdir}/0-parse_summary.log", 'w') do |f|
      STDERR.puts f.path
      f.puts "\n### Same Result on RACCParser and StringManualParser ? \n [#{dif1}, #{dif2}]"
      unless dif1
        PP.pp(defx1, f)
        f.puts ''
        PP.pp(defx2, f)
      end
      unless dif2
        PP.pp(effx1, f)
        f.puts ''
        PP.pp(effx2, f)
      end
    end


    cfgs, zones, aliass = defx1
    File.open("#{tmpdir}/1-defined_config_summary.log", 'w') do |f|
      STDERR.puts f.path
      f.puts "\n#### Defined config summary: \ncfgs: #{cfgs.size}  zones: #{zones.size}  aliass: #{aliass.size}"
      PP.pp({'all config'=>cfgs}, f, 220)
      f.puts ''
      PP.pp({'all zone'=>zones}, f, 220)
      f.puts ''
      PP.pp({'all alias'=>aliass}, f, 220)
    end

    File.open("#{tmpdir}/2-effective_config.log", 'w') do |f|
      STDERR.puts f.path
      f.puts "\n#### Effective config:"
      PP.pp(effx1, f, 220)
    end

    res = defx_split_and_expand_ports(defx1)
    File.open("#{tmpdir}/3-defined_config_split_expand_ports.log", 'w') do |f|
      STDERR.puts f.path
      f.puts "\n#### Show defined config split and expand ports:"
      PP.pp(res, f, 220)
    end

    res = diff_defx_and_effx(defx1, effx1)
    File.open("#{tmpdir}/4-diff_effective_defined_confg.log", 'w') do |f|
      STDERR.puts f.path
      f.puts "\n### Same Result Effective config and Defined config ? \n [#{res}]"
    end

    res = generate_effictive_create_script_from_effx(effx1)
    File.open("#{tmpdir}/5-create_script_from_effective.log", 'w') do |f|
      STDERR.puts f.path
      f.puts "\n\n#### from Effective config generated Create Script:"
      f.puts res
    end

    res = generate_all_create_script_from_defx(defx1)
    File.open("#{tmpdir}/6-create_script_all_from_defined_config.log", 'w') do |f|
      STDERR.puts f.path
      f.puts "\n\n#### from Defined config generated Create Script:"
      f.puts res
    end

    rvs = generate_split_cfg_create_script_from_defx(defx1)
    rvs.each do |k,v|
      File.open("#{tmpdir}/7-create_script_#{k}_from_defined_config.log", 'w') do |f|
        STDERR.puts f.path
        f.puts "\n\n#### from Defined config #{k} generated Create Splited Script:"
        f.puts v
      end
    end

    eff_cfgname = effx1.keys[0]
    res = remove_not_effactive_cfg(defx1, eff_cfgname)
    File.open("#{tmpdir}/8-remove_not_effactive_cfg.log", 'w') do |f|
      STDERR.puts f.path
      f.puts "\n\n#### delete not Effectived config, Keeped {#{eff_cfgname}} :"
      f.puts res
    end
  end

end


if __FILE__ == $0
  fns = []
  gvs1 = global_variables.dup
  while fn = ARGV.shift
    if %w[-h --help].include? fn
      STDERR.puts "\nSyntax:\n  ruby #{File.basename $0} [--keeporder] xx.log [xx.log ..]"
      exit
    elsif fn.start_with? '-'
      fn = fn.sub(/^\-+/,'')
      eval "\$#{fn} = true"
    elsif File.file? fn
      fns << fn
    end
  end
  gvs2 = global_variables.dup
  STDERR.puts "set: #{gvs2 - gvs1}"

  fns.each do |fn|
      STDERR.puts "\n----- #{fn} -----\n"
      SANUtil.parse_file(fn)
  end
end
