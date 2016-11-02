require 'kramdown'
require 'rouge'

module Jekyll
  module Converters
    class DCMarkdownConverter < Converter

      safe true

      def matches(ext)
        ext =~ /^\.md$/i
      end

      def output_ext(ext)
        '.html'
      end

      def convert(content)
        ::Kramdown::Document.new(content, {
          :input                => 'DCKramdown',
          :auto_ids             => @config['kramdown']['auto_ids'],
          :footnote_nr          => @config['kramdown']['footnote_nr'],
          :entity_output        => @config['kramdown']['entity_output'],
          :toc_levels           => @config['kramdown']['toc_levels'],
          :smart_quotes         => @config['kramdown']['smart_quotes'],
          :use_coderay          => @config['kramdown']['use_coderay'],
        }).to_dchtml
      end

    end
  end
end

module Kramdown
  module Parser
    class DCKramdown < Kramdown

      BOXES = %w(aside discussion error information question tip warning)

      def initialize(source, options)
        super
        @block_parsers.unshift(*BOXES.map{ |b| :"#{b}_box" })
      end

      ASIDE_BOX_START = /^#{OPT_SPACE}A> ?/u
      DISCUSSION_BOX_START = /^#{OPT_SPACE}D> ?/
      ERROR_BOX_START = /^#{OPT_SPACE}E> ?/
      INFORMATION_BOX_START = /^#{OPT_SPACE}I> ?/
      QUESTION_BOX_START = /^#{OPT_SPACE}Q> ?/
      TIP_BOX_START = /^#{OPT_SPACE}T> ?/
      WARNING_BOX_START = /^#{OPT_SPACE}W> ?/

      BOXES.each do |box|
        define_method("parse_#{box}_box") do
          result = @src.scan(PARAGRAPH_MATCH)
          while !@src.match?(self.class::LAZY_END)
            result << @src.scan(PARAGRAPH_MATCH)
          end
          result.gsub!(self.class.const_get("#{box.upcase}_BOX_START"), '')

          el = new_block_el(:"#{box}_box")
          @tree.children << el
          parse_blocks(el, result)
          true
        end
        define_parser(:"#{box}_box", self.const_get("#{box.upcase}_BOX_START"))
      end

    end
  end
end

module Kramdown
  module Converter
    class Dchtml < Html

      # Converts the codeblock to HTML, using rouge to highlight.
      #
      def convert_codeblock(el, indent)
        attr = el.attr.dup
        lang = attr['lang']
        lang = 'text' if lang.nil? || lang.empty?
        title = attr['title']
        code = ::Rouge.highlight(el.value, lang, 'html') << "\n"

        output = "<div class=\"codeblock #{lang}"
        output << ' has-caption' if title
        output << '">'
        if title
          title_el = ::Kramdown::Parser::DCKramdown.parse(title).first
          title_html = inner(title_el.children.first, 0)
          output << "<p class=\"caption\">#{title_html}</p>"
        end
        output << "#{code}</div>"
      end

      ::Kramdown::Parser::DCKramdown::BOXES.each do |box|
        define_method("convert_#{box}_box") { |el, indent| <<-EOF }
          #{' '*indent}<div class="box #{box}-box">\n#{inner(el, indent)}#{' '*indent}</div>\n
        EOF
      end

      alias :orin_convert_table :convert_table

      alias :convert_thead :orin_convert_table
      alias :convert_tbody :orin_convert_table
      alias :convert_tfoot :orin_convert_table
      alias :convert_tr    :orin_convert_table

      def convert_table(el, indent)
        title = el.attr.delete('title')
        output = '<div class="table-responsive'
        if title
          title_el = ::Kramdown::Parser::DCKramdown.parse(title).first
          title_html = inner(title_el.children.first, 0)
          output << " has-caption\"><p class=\"caption\">#{title_html}</p>"
        else
          output << '">'
        end
        output << format_as_indented_block_html(el.type, el.attr, inner(el, indent), indent)
        output << '</div>'
      end

    end
  end
end
