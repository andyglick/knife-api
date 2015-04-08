[![Build Status](https://travis-ci.org/andyglick/knife-api.png)](https://travis-ci.org/andyglick/knife-api)
[![Gem Version](https://badge.fury.io/rb/knife-api.svg)](http://badge.fury.io/rb/knife-api)
[![Dependency Status](https://gemnasium.com/andyglick/knife-api.svg)](https://gemnasium.com/andyglick/knife-api)
[![Coverage Status](https://img.shields.io/coveralls/andyglick/knife-api.svg)](https://coveralls.io/r/andyglick/knife-api)
[![Code Climate](https://codeclimate.com/github/andyglick/knife-api/badges/gpa.svg)](https://codeclimate.com/github/andyglick/knife-api)
[![Codeship Status for andyglick/knife-api](https://codeship.com/projects/f10d5f50-4279-0132-4149-5a5e51043d47/status?branch=master)](https://codeship.com/projects/44435)

# Knife-API

Erik Hollensbe first released knife-dsl in November of 2012. His last release took place in December of 2012. Today it 
is September 2014. knife-dsl has 3 pull requests, each of which would relax the existing constraint on the chef version
so that knife-dsl could work with chef 11. 
 
Rather than wait for Erik, I decided to take this on, and to indicate a change of ownership I changed the name of the 
gem to knife-api as I explained below. I released 0.1.1 of knife-api on August 23 2014, and the only change besides the 
name was to bump the compatible chef version to be less than chef 12. Chef 12 is the process of being released so I am
taking a proactive stance and pushing the chef version to any version less than chef 13 with the release of knife-api 
0.1.2.
 
Decided to change the name of this gem from knife-dsl to knife-api because the gem exposes methods from knife, the 
workhorse command line tool from the chef system and makes the methods available to ruby code. A library that lets 
you drive a command line tool programmatically offers an API and is not a DSL.   

A small library that lets you drive Chef's `knife` programmatically

## Installation

Add this line to your application's Gemfile:

    gem 'knife-api'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install knife-api

## Usage

The main feature of this library is the ability to drive knife as a method call
as opposed to an individual program. This has a number of benefits:

* It's a lot faster
* You can capture output
* You're relying on code that has a contract to maintain compatible with Chef
* Use knife plugins all you want without breaking your workflow
* Optionally, Chef becomes constrained by a gemfile (as do the plugins you use)
  and that constraint remains consistent.

It provides two calls, `knife` and `knife_capture` that are injected into the
top-level namespace automatically. Additionally, if you are using `rake`, it
will detect this and make it available to rake's DSL as well.

If you wish to use this code elsewhere, just `include Chef::Knife::API` into
your classes/modules.

Both commands take two argument-passing styles. Both use an array of strings to
represent the ARGV passed to knife, but there is additionally a shorthand to
make the actual subcommand stand out: if you supply a symbol or string with
underscore-delimited subcommand names, it will automatically convert this for
you. This allows you to visually distinguish a command from its arguments.

knife-api allows the use of alternative Chef Configs via the `CHEF_CONFIG`
environment variable.

## Example

Here's a `Rakefile` which lists nodes in one task, and in another, converts the
node metadata supplied by `knife node show $x` to something suitable to display
with `pp`. The practical applications of both tasks are pretty specious, but
they're small and display the functionality.

```ruby
require 'knife/api'
require 'pp'
require 'json'

task :list_nodes do
  status = knife :node_list
  fail if status > 0
end

task :show_node, :node_name do |task_name, args|
  stdout, stderr, status = knife_capture :node_show, [args[:node_name], '-F', 'j']
  fail if status > 0
  pp JSON.load(stdout)
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
