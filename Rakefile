# MagLev Rakefile
#
# Currently, this Rakefile does many, but not all, of the functions in
# bin/gemstone.  Eventually, it will provide all of the functions in
# bin/gemstone, and other MagLev tasks as the need arises.
#
# Ideas for other tasks:
#
# * The rest of the tasks in bin/gemstone (topaz, ruby,...)
# * clean (remove logs etc.)
# * follow-parser: do a tail -f on the parser log
# * git support for typical workflows (see git support in Rubinius Rakefile)
# * allow command line control of the verbosity of the "sh" calls.
#

require 'rake/clean'
require 'rakelib/gemstone'

verbose false  # turn off rake's chatter about all the sh commands

CLEAN.include('*.out', 'log/vmunit*.out', 'log/all*.out')

task :default => :'gs:status'  # TODO: Do we want to leave this as the default?

# This initializes the environment, and then ensures that there is a
# gemstone diretory there.  Needed to pull this out, since some of the
# initialization tasks need to be performed before there is a gemstone dir
# there, but need the ENV var (i.e., need to know where gemstone should
# be).
task :gemstone do
  raise "\nBad GEMSTONE dir: '#{GEMSTONE}'" unless File.directory?(GEMSTONE)
  raise "\nNo etc/maglev.demo.key" unless File.exists?("etc/maglev.demo.key")
end

desc "Run squeak"
task :squeak do
  gem_tools = '/Applications/GemTools-3.0.app'
  if File.exists?(gem_tools)
    sh %{ open #{gem_tools} }
  else
    puts "The #{gem_tools} application used by the 'squeak' command was not found on your system."
    puts "To fix this, correct the 'squeak' command in the gemstone script."
  end
end

desc "Run a .rb file under MagLev: (e.g.: rake gs:maglev file=../foo/bar.rb). Turn on topaz debugging with: rake maglev debug=true file=foo.rb"
task :maglev do
  file = ENV['file']
  debug = ENV['debug'] || false
  raise "No file specified: Specify a file with file=...." if file.nil? || file.empty?
  raise "Can't find file #{file}" unless File.exists?(file)
  code =<<END
run
RubyContext load.
RubyContext loadFileNamed: '#{file}'.
%
exit
END
  run_topaz code, debug
end

desc "Run a ruby file in maglev with debug and parsetree debug: file=..."
task :debug do
  file = ENV['file']
  debug = true
  raise "No file specified: Specify a file with file=...." if file.nil? || file.empty?
  raise "Can't find file #{file}" unless File.exists?(file)
  code =<<END
run
RubyContext load .
RubyParseTreeClient logSexp: true .
RubyContext loadFileNamed: '#{file}' .
%
exit
END
  run_topaz code, debug
end
