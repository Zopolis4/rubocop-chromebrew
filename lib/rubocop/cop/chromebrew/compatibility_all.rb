module RuboCop
  module Cop
    module Chromebrew
      # Compatibility value which match all architectures should be replaced with 'all'.
      #
      # @example
      #   # bad
      #   compatibility 'aarch64 armv7l i686 x86_64'
      #
      #   # good
      #   compatibility 'all'
      #
      class CompatibilityAll < Base
        extend AutoCorrector
        MSG = "Compatibility properties which match all architectures should be replaced with 'all'"

        def_node_matcher :compatibility?, <<~PATTERN
          (send nil? :compatibility
            (str $_))
        PATTERN

        def on_send(node)
          # Check that we're operating on the compatibility property.
          value = compatibility?(node)
          return unless value

          architectures = %w[aarch64 armv7l i686 x86_64]
          # Check if the compatibility value includes all four architectures.
          return unless architectures.all? { |arch| value.include?(arch) }

          # If requested, replace the offending line with compatibility 'all'.
          add_offense(node) do |corrector|
            corrector.replace(node, "compatibility 'all'")
          end
        end
      end
    end
  end
end
