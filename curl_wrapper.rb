#!/usr/bin/env ruby

args = ['curl', '-s'] + ARGV
puts args.map { |arg|
  arg =~ / / ? "'#{arg}'" : arg
}.join(" ")
system(*args)
puts "\n\n"
exit $?.signaled? ? $?.termsig + 128 : $?.exitstatus
