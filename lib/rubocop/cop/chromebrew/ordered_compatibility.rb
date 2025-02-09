module RuboCop
  module Cop
    module Chromebrew
      # Compatibility values should be in alphabetic order.
      #
      # @example
      #   # bad
      #   compatibility 'x86_64 aarch64 armv7l'
      #
      #   # good
      #   compatibility 'aarch64 armv7l x86_64'
      #
      class OrderedCompatibility < Base
        extend AutoCorrector
        MSG = 'Compatibility values should be in alphabetical order.'

        def_node_matcher :compatibility?, <<~PATTERN
          (send nil? :compatibility
            (str $_))
        PATTERN

        def on_send(node)
          # Check that we're operating on the compatibility property.
          value = compatibility?(node)
          return unless value

          sorted_value = value.split.sort.join(' ')

          return if sorted_value == value

          # If requested, replace the offending compatibility value with the sorted version.
          add_offense(node.children.last) do |corrector|
            corrector.replace(node.children.last, "'#{sorted_value}'")
          end
        end
      end
    end
  end
end
