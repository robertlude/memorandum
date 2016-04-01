require_relative './lib/memorandum/version'

Gem::Specification.new do |gem_specification|
  {
    author:   'Robert Lude',
    date:     '2016-04-01',
    email:    'rob@ertlu.de',
    homepage: 'https://www.github.com/robertlude/memorandum',
    license:  'MIT',
    name:     'memorandum',
    summary:  'Provides a simple method to define memoized values',
    version:  Memorandum::VERSION,

    files: %w[
      lib/memorandum.rb
      lib/memorandum/version.rb
    ],
  }.each { |key, value| gem_specification.send "#{key}=", value }

  {
    byebug: nil,
    rspec:  ['>= 3', '< 4'],
  }.each do |gem_name, version|
    gem_specification.add_development_dependency gem_name, *Array(version)
  end
end
