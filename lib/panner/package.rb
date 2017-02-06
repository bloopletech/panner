class Panner::Package
  attr_reader :root, :paths

  def initialize(root)
    raise "root must be an instance of Pathname" unless root.is_a?(Pathname)

    @root = root

    @paths = []
  end

  def agent
    @agent ||= create_agent
  end

  def add(path, content = nil)
    file = (@root + path)
    file.write(content) unless content.nil?
    @paths << file
  end

  def create_agent
    agent = Mechanize.new
    agent.pluggable_parser['image'] = Panner::PackageFileSaver.for(self)
    agent
  end
end