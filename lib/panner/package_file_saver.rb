class Panner::PackageFileSaver < Mechanize::Download
  def self.package
    @package
  end

  def initialize(*args)
    super(*args)

    @package = self.class.package

    if(path.to_s.bytes.length > 256)
      @filename = "#{SecureRandom.hex(16)}#{Pathname.new(@filename).extname}}"
    end

    save(path)

    @package.add(@filename)
  end

  def path
    @package.root + @filename
  end

  def self.for(package)
    Class.new self do |klass|
      klass.instance_variable_set :@package, package
    end
  end
end
