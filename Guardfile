# -*- mode: ruby -*-
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec-jruby' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
end

