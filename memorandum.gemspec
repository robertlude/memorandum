require_relative './lib/memorandum/version'

Gem::Specification.new do |gem_specification|
  {
    author:   'Robert Lude',
    date:     '2017-02-10',
    email:    'rob@ertlu.de',
    homepage: 'https://www.github.com/robertlude/memorandum',
    license:  'MIT',
    name:     'memorandum',
    summary:  'Provides a simple method to memoize method results',
    version:  Memorandum::VERSION,

    files: %w[
      lib/memorandum.rb
      lib/memorandum/version.rb
    ],

    description: 'Memorandum provides a simple method to memoize method ' \
                 'results. It also provides flags for freezing the cached ' \
                 'results.'
  }.each { |key, value| gem_specification.send "#{key}=", value }

  {
    ice_nine: '0.11.2'
  }.each do |gem_name, version|
    gem_specification.add_runtime_dependency gem_name, *Array(version)
  end

  {
    rspec:  ['>= 3', '< 4'],
  }.each do |gem_name, version|
    gem_specification.add_development_dependency gem_name, *Array(version)
  end
end
