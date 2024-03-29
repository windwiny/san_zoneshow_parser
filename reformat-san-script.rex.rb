#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.7
# from lexical definition file "reformat-san-script.rex".
#++

require 'racc/parser'
class SCC < Racc::Parser
      require 'strscan'

      class ScanError < StandardError ; end

      attr_reader   :lineno
      attr_reader   :filename
      attr_accessor :state

      def scan_setup(str)
        @ss = StringScanner.new(str)
        @lineno =  1
        @state  = nil
      end

      def action
        yield
      end

      def scan_str(str)
        scan_setup(str)
        do_parse
      end
      alias :scan :scan_str

      def load_file( filename )
        @filename = filename
        File.open(filename, "r") do |f|
          scan_setup(f.read)
        end
      end

      def scan_file( filename )
        load_file(filename)
        do_parse
      end


        def next_token
          return if @ss.eos?

          # skips empty actions
          until token = _next_token or @ss.eos?; end
          token
        end

        def _next_token
          text = @ss.peek(1)
          @lineno  +=  1  if text == "\n"
          token = case @state
            when nil
          case
                  when (text = @ss.scan(/\s+/))
                     action {  } #nothing

                  when (text = @ss.scan(/\#.+/))
                     action {  } #nothing

                  when (text = @ss.scan(/^--.+/))
                     action {  } #nothing

                  when (text = @ss.scan(/","|dominID|alicreate|zonecreate|cfgcreate|cfgadd|cfgsave|cfgenable|aliadd|aliremove|zoneadd|zoneremove|cfgremove/))
                     action {
                   [text, text] }


                  when (text = @ss.scan(/\d+,\d+/))
                     action { [:PORT, text] }

                  when (text = @ss.scan(/\w{2}(:\w{2}){7}/))
                     action { [:WWPN, text] }

                  when (text = @ss.scan(/\d+/))
                     action { [:NUMBER, text] }

                  when (text = @ss.scan(/\w(\w|-)*/))
                     action { [:NAME, text] }

                  when (text = @ss.scan(/.|\n/))
                     action { [text, text] }

          
          else
            text = @ss.string[@ss.pos .. -1]
            raise  ScanError, "can not match: '" + text + "'"
          end  # if

        else
          raise  ScanError, "undefined state: '" + state.to_s + "'"
        end  # case state
          token
        end  # def _next_token

end # class

      if __FILE__ == $0
        exit  if ARGV.size != 1
        filename = ARGV.shift
        rex = SCC.new
        begin
          rex.load_file  filename
          while  token = rex.next_token
            p token
          end
        rescue
          $stderr.printf  "%s:%d:%s\n", rex.filename, rex.lineno, $!.message
        end
      end
