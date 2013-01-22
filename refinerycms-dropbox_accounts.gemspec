# Encoding: UTF-8

Gem::Specification.new do |s|
  s.authors           = ['Alex Pauly']
  s.email             = 'alex.pauly@gmx.de'
  s.homepage          = 'https://github.com/apauly/refinery-dropbox_accounts'
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-dropbox_accounts'
  s.version           = '1.0'
  s.description       = 'Dropbox Sync for Refinery CMS'
  s.date              = '2013-01-22'
  s.summary           = 'Dropbox Accounts lets you upload any files to Refinery CMS vía Dropbox'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '~> 2.0.9'
  s.add_dependency             'dropbox-api'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '~> 2.0.9'
end
