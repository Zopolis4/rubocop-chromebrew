Gem::Specification.new do |spec|
  spec.name     = 'rubocop-chromebrew'
  spec.summary  = 'A RuboCop extension for Chromebrew-specific practices.'
  spec.version  = '0.0.5'
  spec.license  = 'GPL-3.0-or-later'
  spec.author   = 'Zopolis4'
  spec.email    = 'creatorsmithmdt@gmail.com'
  spec.homepage = 'https://github.com/chromebrew/rubocop-chromebrew'

  spec.metadata['default_lint_roller_plugin'] = 'RuboCop::Chromebrew::Plugin'

  spec.files         = `git ls-files`.split("\n")
  spec.require_paths = ['lib']

  spec.add_dependency 'lint_roller'
  spec.add_dependency 'rubocop'
end
