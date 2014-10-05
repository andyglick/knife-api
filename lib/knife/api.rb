require 'chef/application/knife'
require 'knife/api/version'
require 'stringio'

module Chef
  module Knife
    # adding API module to existing Chef::Knife packaging
    module API
      # adding Support module
      module Support
        def self.run_knife(command, args)
          unless command.is_a?(Array)
            command = command.to_s.split(/[\s_]+/)
          end

          command += args

          if ENV['CHEF_CONFIG']
            command += ['-c', ENV['CHEF_CONFIG']]
          end

          opts = Chef::Application::Knife.new.options
          Chef::Knife.run(command, opts)
          return 0
        rescue SystemExit => e
          return e.status
        end
      end

      def knife(command, args = [])
        Chef::Knife::API::Support.run_knife(command, args)
      end

      def knife_capture(command, args = [], input = nil)
        null = Gem.win_platform? ? File.open('NUL:', 'r') : File.open('/dev/null', 'r')

        warn = $VERBOSE
        $VERBOSE = nil
        stderr, stdout, stdin = STDERR, STDOUT, STDIN

        Object.const_set('STDERR', StringIO.new('', 'r+'))
        Object.const_set('STDOUT', StringIO.new('', 'r+'))
        Object.const_set('STDIN', input ? StringIO.new(input, 'r') : null)
        $VERBOSE = warn

        status = Chef::Knife::API::Support.run_knife(command, args)
        return STDOUT.string, STDERR.string, status
      ensure
        warn = $VERBOSE
        $VERBOSE = nil
        Object.const_set('STDERR', stderr)
        Object.const_set('STDOUT', stdout)
        Object.const_set('STDIN', stdin)
        $VERBOSE = warn
        null.close
      end
    end
  end
end

class << eval("self", TOPLEVEL_BINDING)
  include Chef::Knife::API
end

if defined? Rake::API
  module Rake
    # adding the API module to Rake in the context of this gem
    module API
      include Chef::Knife::API
    end
  end
end
