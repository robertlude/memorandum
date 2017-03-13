require 'fileutils'
require 'rubygems'
require 'hoe'

Hoe.plugin :compiler

Hoe.spec 'memorandum' do
  developer 'Robert Lude', 'rob@ertlu.de'
  license   'MIT'

  dependency 'ice_nine', '0.11.2'

  dependency 'rake-compiler', '~> 1.0', :dev
  dependency 'rspec',         '~> 3.0', :dev

  extension 'memorandum'

  # TODO is there a nicer way to do this beside stupid readme formatting?
  self.urls = Hash code: 'https://www.github.com/robertlude/memorandum'
end

# clean up after compile

Rake::Task['compile'].enhance do
  FileUtils.rm_rf 'tmp'
end

# unwanted / unconfigured things

tasks = Rake.application.instance_variable_get '@tasks'

%w[
  announce
  audit
  dcov
  debug_email
  docs
  generate_key
  post_blog
  publish_docs
  ridocs
  test
].each { |task| tasks.delete task }

