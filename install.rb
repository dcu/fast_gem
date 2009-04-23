#!/usr/bin/env ruby

require 'rbconfig'
require 'fileutils'

FileUtils.install(File.dirname(__FILE__)+"/lib/fast_gem.rb", RbConfig::CONFIG["rubylibdir"]+"/fast_gem.rb", :verbose => true)

