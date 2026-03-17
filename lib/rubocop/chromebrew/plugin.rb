require 'lint_roller'

module RuboCop
  module Chromebrew
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: 'rubocop-chromebrew',
          version: '0.0.4',
          homepage: 'https://github.com/chromebrew/rubocop-chromebrew',
          description: 'A RuboCop extension for Chromebrew-specific practices.'
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: Pathname.new(__dir__).join('../../../config/default.yml')
        )
      end
    end
  end
end
