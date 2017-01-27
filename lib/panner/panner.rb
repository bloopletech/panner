class Panner::Panner
  def initialize(options)
    @options = options
    puts "@options: #{@options.inspect}"
  end
  
  def start
    pan = Panner::Pans::Wordpress.new(@options[:url])
    
    nuggets = []

    loop do
      fresh_nuggets = pan.download
      break if fresh_nuggets.nil?

      nuggets.concat(fresh_nuggets)
      pan.next
    end

    nuggets.each do |nugget|
      puts nugget.inspect
      puts "======================================================================================================="
    end
  end
end