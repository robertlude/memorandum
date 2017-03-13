require 'hoe'

Hoe.spec 'memorandum' do
  developer 'Robert Lude', 'rob@ertlu.de'
  license   'MIT'

  dependency 'ice_nine', '0.11.2'

  dependency 'rspec', '~> 3.0', :dev

  self.urls = Hash code: 'https://www.github.com/robertlude/memorandum'
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
