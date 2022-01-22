module AIRAC

  # Executable instantiated by the console tools
  class Executable
    attr_reader :options

    def initialize
      @options = {
        format: nil,
        offset: 0
      }
      OptionParser.new do |o|
        o.banner = <<~END
          Calculate AIRAC cycle from four digit ID or date within (default: today).
          Usage: #{File.basename($0)} [options] [cycle]
        END
        o.on('-f', '--format TEMPLATE', String, "Template for strftime with %i for cycle ID") { @options[:format] = _1 }
        o.on('-o', '--offset INTEGER', Integer, "Offset by this many cycles") { @options[:offset] = _1.to_i }
        o.on('-A', '--about', 'show author/license information and exit') { about }
        o.on('-V', '--version', 'show version and exit') { version }
      end.parse!
      @options[:raw_cycle] = ARGV.shift || Date.today
    end

    def run
      puts (AIRAC::Cycle.new(options[:raw_cycle]) + options[:offset].to_i).to_s(options[:format])
    rescue => error
      message = error.respond_to?(:original_message) ? error.original_message : error.message
      puts "ERROR: #{message}"
    end

    private

    def about
      puts 'Written by Sven Schwyn (bitcetera.com) and distributed under MIT license.'
      exit
    end

    def version
      puts AIRAC::VERSION
      exit
    end

  end
end
