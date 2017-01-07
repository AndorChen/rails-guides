module Persie
  class MultipleHTMLs
    # Run after build complete
    def after_build
      rename_toc
    end

    private

    # Renames toc.html to index.html
    def rename_toc
      base = File.join @book.builds_dir, 'html', 'multiple'
      puts
      info 'Renaming toc.html...'
      FileUtils.mv File.join(base, 'toc.html'), File.join(base, 'index.html')
      fix_link
      confirm '    Done'
      puts
    end

    def fix_link
      base = File.join @book.builds_dir, 'html', 'multiple'
      index_file = File.join base, 'index.html'
      index_root = ::Nokogiri::HTML.fragment File.read(index_file)

      # delete secondary toc
      index_root.css('li[data-type="chapter"] > ol').unlink

      # remove parts' link
      index_root.css('li[data-type="part"]').each do | part|
        part.first_element_child.replace("<span class=\"part-title\">#{part.first_element_child.text}</span>")
      end

      text = index_root.to_s.sub('permalink: /book/toc.html', 'permalink: /book/index.html')

      File.write index_file, text
    end
  end
end
