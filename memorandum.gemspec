require_relative './lib/memorandum/version'

Gem::Specification.new do |holotype|
  Hash[
    author:   'Robert Lude',
    date:     '2017-08-11',
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
  ].each do |key, value|
    holotype.public_send "#{key}=", value
  end

  Hash[
    runtime: {
      'ice_nine' => '0.11.2',
    },
    development: {
      'byebug' => nil,
      'rspec'  => '~> 3.6',
    },
  ].each do |environment, gems|
    gems.each do |name, version|
      holotype.public_send("add_#{environment}_dependency", name, version)
    end
  end
end
