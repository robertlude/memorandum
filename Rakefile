require 'rubygems'
require 'hoe'

Hoe.plugin :compiler

Hoe.spec 'memorandum' do
  developer 'Robert Lude', 'rob@ertlu.de'
  license   'MIT'

  dependency 'ice_nine', '0.11.2'

  dependency 'rake-compiler', '~> 1.0', :dev
  dependency 'rspec',         '~> 3.0', :dev

  self.urls = Hash code: 'https://www.github.com/robertlude/memorandum'

  extension 'memorandum'

  # TODO cleanup
  # Rake::ExtensionTask.new('memorandum', spec) do |ext|
  #   ext.lib_dir = File.join('lib')
  # end
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

