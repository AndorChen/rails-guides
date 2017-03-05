require 'asciidoctor'
require 'asciidoctor/extensions'

module RailsGuides
  # Register a `term' inline macro to define terminology.
  #
  # Example
  #
  #   There is a terminology called term:[application].
  #
  # Output
  #
  #   There is a terminology called <span class="terminology">application</span>.
  class TermInlineMacro < ::Asciidoctor::Extensions::InlineMacroProcessor
    use_dsl

    named :term
    using_format :short
    name_attributes 'term'

    def process parent, target, attributes
      %(<span class="terminology">#{target}</span>)
    end
  end
end

::Asciidoctor::Extensions.register do
  inline_macro ::RailsGuides::TermInlineMacro
end
