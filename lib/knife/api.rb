require 'chef/application/knife'
require 'knife/api/version'
require 'stringio'

# Chef::Knife classes are opened to expose the Knife entry points to code
# via the injected API module
class Chef
  class Knife
    # adding API module to existing Chef::Knife packaging
    module API
      # adding Support module
      module Support
        def self.run_knife(command, args)
          command = command.to_s.split(/[\s_]+/) unless command.is_a?(Array)
          command += args
          command += ['-c', ENV['CHEF_CONFIG']] if ENV['CHEF_CONFIG']

          opts = Chef::Application::Knife.new.options
          Chef::Knife.run(command, opts)
          # believe this to be a problem -- if knife command would otherwise
          # indicate a chef error this creates a false positive
          0
        rescue SystemExit => e
          abort("Chef run failed with status " + e.status.to_s)
        end
      end

      def knife(command, args = [])
        Chef::Knife::API::Support.run_knife(command, args)
      end

      def knife_capture(command, args = [], input = nil)
        @input = input
        set_null

        assign_io_channels

        status = Chef::Knife::API::Support.run_knife(command, args)
        return STDOUT.string, STDERR.string, status
      ensure
        revert_io_channels
      end
    end
  end

  def set_null
    if Gem.win_platform? == null
      File.open('NUL:', 'r')
    else
      File.open('/dev/null', 'r')
    end
  end

  def assign_io_channels
    @warn = $VERBOSE
    $VERBOSE = nil
    @stderr = STDERR
    @stdout = STDOUT
    @stdin = STDIN

    Object.const_set('STDERR', StringIO.new('', 'r+'))
    Object.const_set('STDOUT', StringIO.new('', 'r+'))
    Object.const_set('STDIN', @input ? StringIO.new(@input, 'r') : null)
    $VERBOSE = @warn
  end

  def revert_io_channels
    @warn = $VERBOSE
    $VERBOSE = nil
    Object.const_set('STDERR', @stderr)
    Object.const_set('STDOUT', @stdout)
    Object.const_set('STDIN', @stdin)
    $VERBOSE = @warn
    null.close
  end
end

class << eval('self', TOPLEVEL_BINDING)
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
