# Copyright (c) 2006-2014 The University of Manchester, UK.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#  * Neither the names of The University of Manchester nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# Author: Robert Haines

require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rdoc/task'
require 'rubygems/package_task'

task :default => [:test]

spec = Gem::Specification.new do |s|
  s.name             = "taverna-baclava"
  s.version          = "1.0.1"
  s.author           = "Robert Haines"
  s.email            = "rhaines@manchester.ac.uk"
  s.homepage         = "http://www.taverna.org.uk/"
  s.platform         = Gem::Platform::RUBY
  s.summary          = "Ruby support for the Baclava file format."
  s.description      = "A Ruby library to support the reading and writing " +
                         "of the Baclava data format."
  candidates         = Dir.glob("{lib,test}/**/*")
  s.files            = candidates.delete_if {|item| item.include?("rdoc")}
  s.require_path     = "lib"
  s.test_file        = "test/ts_baclava.rb"
  s.has_rdoc         = true
  s.extra_rdoc_files = ["ReadMe.rdoc", "Licence.rdoc", "Changes.rdoc"]
  s.rdoc_options     = ["-N", "--tab-width=2", "--main=ReadMe.rdoc"]
  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rdoc', '>= 3.9.4')
  s.add_runtime_dependency('builder', '~> 3.0')
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/ts_baclava.rb']
  t.verbose = true
end

RDoc::Task.new do |r|
  r.main = "ReadMe.rdoc"
  lib = Dir.glob("lib/**/*.rb").delete_if do |item|
    item.include?("taverna-baclava.rb")
  end
  r.rdoc_files.include("ReadMe.rdoc", "Licence.rdoc", "Changes.rdoc", lib)
  r.options << "-t Taverna Baclava Ruby Library version 1.0.1"
  r.options << "-N"
  r.options << "--tab-width=2"
end
