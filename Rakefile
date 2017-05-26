require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'asciidoctor'

desc 'Build pdf format'
task :pdf do
  system 'bundle exec persie build pdf'
end

desc 'Build pdf sample'
task :sample do
  system 'bundle exec persie build pdf -s'
end

desc 'Build epub format'
task :epub do
  system 'bundle exec persie build epub -c'
end

desc 'Build mobi format'
task :mobi do
  system 'bundle exec persie build mobi'
end

desc 'Build site format'
task :site do
  system 'bundle exec persie build html -m'
end

desc 'Convert to Markdown format'
task :md do
  FileUtils.mkdir_p 'builds/markdown'
  FileUtils.rm Dir['builds/markdown/*']
  FileUtils.mkdir_p 'tmp/markdown'

  bottle = {}
  puts "Collecting refids"
  Dir.glob("manuscript/*.adoc") do |f|
    doc = Asciidoctor.load_file(f)
    refids = doc.references[:ids]

    refids.each do |_, v|
      v.gsub!(/<code>|<\/code>/, '`')
    end

    bottle.merge! refids
  end
  File.open('tmp/markdown/refs.yml', 'w') { |f| f.write(bottle.to_yaml) }

  excludes = [
    'contributing',
    'controllers',
    'digging_depper',
    'extending_rails',
    'foreword',
    'maintenance',
    'models',
    'release_notes',
    'start_here',
    'supplement',
    'views'
  ]

  files = FileList.new('manuscript/*.adoc')
  files.exclude(excludes.map { |n| "manuscript/#{n}.adoc"})
  files.each do |f|
    puts "Converting #{File.basename(f)}"
    asciidoc = File.open(f).read

    imagesdir = "images"
    imagesdir << "/#{File.basename(f, '.adoc')}" if ['getting_started', 'i18n'].include?(File.basename(f, '.adoc'))
    markdown = Asciidoctor.convert( asciidoc,
                                    template_dir: 'md_tpl',
                                    template_engine_options: { erb: { trim: '-' } },
                                    attributes: {
                                      'imagesdir' => imagesdir
                                    }
                                  )

    # weird, you cannot use `**' etc directly in templates
    markdown.gsub!('<!--emphasis-->',   '_')
    markdown.gsub!('<!--strong-->',     '**')
    markdown.gsub!('<!--monospaced-->', '`')

    filename = "#{File.basename(f,'.*')}.md"
    File.open("builds/markdown/#{filename}", 'w') { |f| f.write(markdown) }
  end

end

desc 'Preview site'
task :preview do
  system 'bundle exec persie preview multiple'
end
