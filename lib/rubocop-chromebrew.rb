require 'rubocop'

require_relative 'rubocop/chromebrew'
require_relative 'rubocop/chromebrew/inject'

RuboCop::Chromebrew::Inject.defaults!

require_relative 'rubocop/cop/chromebrew_cops'
