require "optparse"

class Panner::CLI
  def run(arguments)
    options = {}

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: panner [options] URL"

      opts.on("-uUSERNAME", "--username=USERNAME", "Username") do |username|
        options[:username] = username
      end
      
      opts.on("-pPASSWORD", "--password=PASSWORD", "Username") do |password|
        options[:password] = password
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end
    
    opt_parser.parse!(arguments)
    options[:url] = arguments.first
    
    Panner::Panner.new(options).start
  end
end
    
    