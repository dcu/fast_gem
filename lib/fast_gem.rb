
require 'rbconfig'

class FastGem
  class << self
    attr_accessor :gem_paths
  end
  self.gem_paths = []

  class Version
    attr_reader :major, :minor, :v
    def initialize(*args)
      @major = args[0].to_i
      @minor = args[1].to_i
      @v = args[2].to_i
    end

    def <=>(other)
        return -1 if @major < other.major
        return -1 if @minor < other.minor
        return -1 if @v < other.v
        1
    end
  end

  def self.load_gem(name, version = nil)
    path = nil
    self.gem_paths.each do |e|
      break if path = Dir.glob(e+"/#{name}-#{version}*").sort_by { |e|
        Version.new(*e.split("-").last.to_s.split("."))
      }.last
    end
    return false if path.nil?

    $:.unshift path+"/lib"
    begin
      require name
    rescue LoadError
    end
    true
  end
end

FastGem.gem_paths << File.expand_path("#{RbConfig::CONFIG["rubylibdir"]}/../gems/"+
                                      "#{RbConfig::CONFIG["ruby_version"]}/gems")

module Kernel
  def fast_gem(name, version = nil)
    FastGem.load_gem(name, version)
  end
end
