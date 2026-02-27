# frozen_string_literal: true

source 'https://rubygems.org'

# Puppet and Facter — version controllable via environment
# PUPPET_GEM_VERSION overrides for CI; default aligns with metadata.json
puppet_gem_version = ENV.fetch('PUPPET_GEM_VERSION', nil)
if puppet_gem_version
  gem 'puppet', puppet_gem_version, require: false
else
  gem 'puppet', '>= 7.0.0', '< 9.0.0', require: false
end
gem 'facter', require: false

# Test and CI dependencies (outside :development so gha-puppet CI can use them)
gem 'deep_merge',                    '~> 1.2.2',  require: false
gem 'facterdb',                      '~> 3.0',    require: false
gem 'json',                          '= 2.6.3',   require: false
gem 'json-schema',                   '< 5.1.1',   require: false
gem 'metadata-json-lint',            '~> 4.0',    require: false
gem 'parallel_tests',                '= 3.12.1',  require: false
gem 'puppet_metadata',               '~> 3.4',    require: false
gem 'puppetlabs_spec_helper',        '~> 8.0',    require: false
gem 'rspec-puppet-facts',            '~> 5.0',    require: false
gem 'rubocop',                       '~> 1.50.0', require: false
gem 'rubocop-performance',           '= 1.16.0',  require: false
gem 'rubocop-rspec',                 '= 2.19.0',  require: false
gem 'simplecov-console',             '~> 0.9',    require: false
gem 'voxpupuli-puppet-lint-plugins', '~> 5.0',    require: false

# Development-only tools (excluded from CI via BUNDLE_WITHOUT)
group :development do
  gem 'dependency_checker', '~> 1.0.0',  require: false
  gem 'pry',                '~> 0.10',   require: false
  gem 'puppet-debugger',    '~> 1.6',    require: false
  gem 'rb-readline',        '= 0.5.5',   require: false, platforms: [:mswin, :mingw, :x64_mingw]
  gem 'bigdecimal',         '< 3.2.2',   require: false, platforms: [:mswin, :mingw, :x64_mingw]
end

# Release preparation tools
group :release_prep do
  gem 'puppet-blacksmith', '~> 7.0', require: false
  gem 'puppet-strings',    '~> 4.0', require: false
end

# Acceptance/system testing (excluded from CI unit tests via BUNDLE_WITHOUT)
group :system_tests do
  gem 'puppet_litmus',  '~> 1.0',   require: false, platforms: [:ruby, :x64_mingw]
  gem 'CFPropertyList',  '< 3.0.7', require: false, platforms: [:mswin, :mingw, :x64_mingw]
  gem 'serverspec',      '~> 2.41',  require: false
end

# Evaluate Gemfile.local and ~/.gemfile if they exist
extra_gemfiles = [
  "#{__FILE__}.local",
  File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  next unless File.file?(gemfile) && File.readable?(gemfile)

  eval(File.read(gemfile), binding) # rubocop:disable Security/Eval
end
