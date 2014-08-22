require 'chef/application/knife'
require 'knife/api/version'
require 'stringio'

module Chef::Knife::API
  module Chef::Knife::API::Support
    def self.run_knife(command, args)
      unless command.kind_of?(Array)
        command = command.to_s.split(/[\s_]+/)
      end

      command += args

      if ENV["CHEF_CONFIG"]
        command += ['-c', ENV["CHEF_CONFIG"]]
      end

      opts = Chef::Application::Knife.new.options
      Chef::Knife.run(command, opts)
      return 0
    rescue SystemExit => e
      return e.status
    end
  end

  def knife(command, args=[])
    Chef::Knife::API::Support.run_knife(command, args)
  end

  def knife_capture(command, args=[], input=nil)
    null = Gem.win_platform? ? File.open('NUL:', 'r') : File.open('/dev/null', 'r')

    warn = $VERBOSE 
    $VERBOSE = nil
    stderr, stdout, stdin = STDERR, STDOUT, STDIN

    Object.const_set("STDERR", StringIO.new('', 'r+'))
    Object.const_set("STDOUT", StringIO.new('', 'r+'))
    Object.const_set("STDIN", input ? StringIO.new(input, 'r') : null)
    $VERBOSE = warn

    status = Chef::Knife::API::Support.run_knife(command, args)
    return STDOUT.string, STDERR.string, status
  ensure
    warn = $VERBOSE 
    $VERBOSE = nil
    Object.const_set("STDERR", stderr)
    Object.const_set("STDOUT", stdout)
    Object.const_set("STDIN", stdin)
    $VERBOSE = warn
    null.close
  end
end

class << eval("self", TOPLEVEL_BINDING)
  include Chef::Knife::API
end

if defined? Rake::API
  module Rake::API
    include Chef::Knife::API
  end
end
