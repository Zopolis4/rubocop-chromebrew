Gem::Specification.new do |spec|
  spec.name     = 'rubocop-chromebrew'
  spec.summary  = 'A RuboCop extension for Chromebrew-specific practices.'
  spec.version  = '0.0.2'
  spec.license  = 'GPL-3.0-or-later'
  spec.author   = 'Zopolis4'
  spec.email    = 'creatorsmithmdt@gmail.com'
  spec.homepage = 'https://github.com/chromebrew/rubocop-chromebrew'

  spec.files         = `git ls-files`.split("\n")
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rubocop'
end
