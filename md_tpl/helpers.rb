require 'cgi/util'
require 'asciidoctor'
require 'asciidoctor/extensions'

module Rebus
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

    def process parent, target, attributes
      target
    end
  end

  module Helpers

    CHAPTER_IDS = [
      'ruby-on-rails-5-0-release-notes',
      'ruby-on-rails-5-1-release-notes',
      'action-cable-overview',
      'action-controller-overview',
      'action-mailer-basics',
      'action-view-overview',
      'active-jobs-basics',
      'active-model-basics',
      'active-record-basics',
      'active-record-callbacks',
      'active-record-migrations',
      'active-record-query-interface',
      'active-record-validations',
      'active-support-core-extensions',
      'active-support-instrumentation',
      'using-rails-for-api-only-applications',
      'api-documentation-guidelines',
      'the-asset-pipeline',
      'active-record-associations',
      'autoloading-and-reloading-constants',
      'caching-with-rails-an-overview',
      'the-rails-command-line',
      'configuring-rails-applications',
      'contributing-to-ruby-on-rails',
      'debugging-rails-applications',
      'development-dependencies-install',
      'getting-started-with-engines',
      'action-view-form-helpers',
      'creating-and-customizing-rails-generators-and-templates',
      'getting-started-with-rails',
      'rails-internationalization-api',
      'the-rails-initialization-process',
      'layouts-and-rendering-in-rails',
      'maintenance-policy-for-ruby-on-rails',
      'the-basics-of-creating-rails-plugins',
      'a-guide-to-profiling-rails-applications',
      'rails-application-templates',
      'rails-on-rack',
      'rails-routing-from-the-outside-in',
      'ruby-on-rails-guides-guidelines',
      'ruby-on-rails-security-guide',
      'a-guide-to-testing-rails-applications',
      'a-guide-for-upgrading-ruby-on-rails',
      'working-with-javascript-in-rails'
    ]

    def self.get_xref_text(id)
      id = id.include?('#') ? id.split('#', 2).last : id

      refs_file = File.expand_path('../../tmp/markdown/refs.yml', __FILE__)
      refs = YAML.load_file(refs_file)

      refs[id]
    end

    def self.get_xref_target(target)
      return target unless target.include? '.html#'

      parts = target.split('#', 2)
      return parts.first if CHAPTER_IDS.include? parts.last

      target
    end

    def self.indent(text, space=4)
      lines = []
      text.each_line { |l| lines << l.prepend(' ' * space) }
      lines.join
    end

  end
end

::Asciidoctor::Extensions.register do
  inline_macro ::Rebus::TermInlineMacro
end
