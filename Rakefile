require 'bundler/gem_tasks'

require 'knife/api'
require 'pp'
require 'json'

task :list_nodes do
  status = knife :node_list
  puts "status is #{status}"
  fail if status > 0
end

task :show_node, :node_name do |task_name, args|
  stdout, stderr, status = knife_capture :node_show, [args[:node_name], '-F', 'j']
  fail if status > 0
  pp JSON.load(stdout)
end
