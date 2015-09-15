#!/usr/bin/env ruby

require 'Open3'
require 'English'
require 'date'
require 'yaml'
require 'fileutils'

pandoc_path = `which pandoc`.strip
if pandoc_path.empty?
  puts 'Could not find pandoc on your $PATH. Please install it and run again.'
  puts 'If you have Homebrew installed, you can run `brew install pandoc`.'
  exit
end

format = ARGV[0] || 'pdf'
directory = File.expand_path(File.dirname(__FILE__))
files = Dir[File.join(directory, 'Chapter*', '*.md')]
files.each do |file|
  content = File.open(file, 'r') { |f| f.read }
  content.gsub! /\n\r/, "\n"
  content.encode!(content.encoding, universal_newline: true)
  File.open(file, 'w') { |f| f.write content }
end

cover_path = File.join(directory, "Cover", "Cover-Art.jpg")
style_path = File.join(directory, "style.css")

puts style_path

metadata = {
  'title' => 'Achieving Zen with Auto Layout',
  'author' => 'Justin Williams',
  'language' => 'en-US',
  'rights' => "(c) #{Date.today.year} Justin Williams. All rights reserved."
}.to_yaml
meta_path = File.join(directory, 'metadata.txt')
File.open(meta_path, 'w') { |f| f.write metadata }

destination = File.join(directory, 'build',
                        "Achieving Zen with Auto Layout.#{format}")
unless File.directory?(File.dirname(destination))
  FileUtils.mkdir_p(File.dirname(destination))
end

output = %Q(pandoc -S -s --smart -o "#{destination}" )
output << %Q(--epub-metadata="#{File.basename(meta_path)}" ) if format == 'epub'
output << %Q(--epub-cover-image="#{cover_path}" ) if format == 'epub'
output << %Q(--epub-stylesheet="#{style_path}" ) if format == 'epub'
output << %Q(--latex-engine=xelatex ) if format == 'pdf'
output << files.map { |f| %Q("#{f}") }.join(' ')


begin
  puts "Generating #{format} file."
  puts output
  out, err, st = Open3.capture3(output)
  fail if st != 0
  puts out.strip
  puts 'Operation complete.'
rescue RuntimeError
  puts "Operation failed: #{err}"
ensure
  puts 'Cleaning up.'
  File.delete(meta_path) if File.exist?(meta_path)
end
