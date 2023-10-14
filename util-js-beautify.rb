fs = ARGV.select { |e| e.end_with? '.js' }
fs = Dir.glob 'webgui*/assets/*.js' if fs.empty?

cmds = []
fs.each do |fn|
  next unless fn.end_with? '.js'
  next if fn.end_with? '-ori.js'

  fn = fn.chomp '.js'
  next if fs.include?("#{fn}-ori.js")

  cmd = %(mv "#{fn}.js" "#{fn}-ori.js")
  cmds << cmd
  cmd = %(js-beautify #{fn}-ori.js > #{fn}.js)
  cmds << cmd
end

puts cmds
puts 'Run it ? (Yes/No)'
cmds.map { |cmd| `#{cmd}` }
if STDIN.gets.strip =~ /^y(es)?$/i
