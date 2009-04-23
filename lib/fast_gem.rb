
require 'rbconfig'

class FastGem
  class << self
    attr_accessor :gem_paths
  end

  self.gem_paths = []

  def self.load_gem(name, version = nil)
    path = nil
    self.gem_paths.each do |e|
      break if path = Dir.glob(e+"/#{name}-#{version}*").first
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
