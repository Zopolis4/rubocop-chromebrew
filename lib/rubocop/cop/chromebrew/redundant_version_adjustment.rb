module RuboCop
  module Cop
    module Chromebrew
      # Adjustments to the version should change the version.
      #
      # @example
      #   # good
      #   version '1.0.0-1'
      #   git_hashtag version.split('-').first
      #
      #   # bad
      #   version '2.3'
      #   git_hashtag version.split('-').first
      #
      #   # good
      #   version '2.3'
      #   git_hashtag version
      #
      class RedundantVersionAdjustment < Base
        extend AutoCorrector

        MSG = 'This version adjustment does not actually change the version.'

        # @!method version_adjustment?(node)
        def_node_matcher :version_adjustment?, <<~PATTERN
          (send `(send nil? :version) ...)
        PATTERN

        # @!method find_package_version?(node)
        def_node_matcher :find_package_version?, <<~PATTERN
          (class (const nil? $_) (const nil? {:Autotools | :CMake | :Meson | :PERL | :Package | :Pip | :Python | :Qmake | :RUBY | :RUST}) `(send nil? :version (str $_)))
        PATTERN

        @@mappings = {}

        # Find and store the original version variable of this package.
        def on_class(node)
          return unless find_package_version?(node)

          package, version = find_package_version?(node)

          @@mappings[package] = version
        end

        def on_send(node)
          # We're only interested in nodes that are working with the version variable.
          return unless version_adjustment?(node)

          # Ensure the node we're processing here is a version adjustment in the format we expect.
          return unless node.source.start_with?('version')

          # Retrieve the original version variable of this package.
          original_version = @@mappings[node.parent_module_name&.to_sym]
          return if original_version.nil?

          # Some packages, such as gcc_lib, use version constants from other packages (gcc_build, in this case).
          # These packages are rare enough that it isn't worth the added complexity that loading those dependent packages would create,
          # so here we just catch and ignore the NameError that results from evaluating the external version constants.
          begin
            # Check if the modifications in this node actually change the version of the package.
            return unless eval(node.source.sub('version', "'#{original_version}'")) == original_version
          rescue NameError
            return
          end

          # If this node doesn't actually modify the version, remove every part of it apart from the literal 'version' at the start of it.
          add_offense(node.source_range.adjust(begin_pos: 'version'.length)) do |corrector|
            corrector.remove(node.source_range.adjust(begin_pos: 'version'.length))
          end
        end
      end
    end
  end
end
