# vim: filetype=ruby
require 'pry'
require 'yaml'
require 'commonmarker'
require 'github/markup'

class Book < Thor
  desc "build", "Export to a single html file"
  @@config   = 'config/config.yaml'

  @@config  = YAML.load_file(@@config)

  @@debug   = @@config['debug']
  @@output  = @@debug ? $stdout.dup : File.open(@@config['output'], 'w')
  @@content = YAML.load_file(@@config['content']['toc'])
  @@presets = @@config['presets']

  def build
    styles = File.read @@presets['css']
    write @@presets['head'].sub!('{STYLES}', styles)
    write @@presets['body']['start']
    write '<h1>' + @@config['title'] + '</h1>'
    write toc

    @@content.each do |c|
      write @@presets['section']['start']
      write '<h1 id="' + c['title'] + '">' + titleize(c['title']) + '</h1>'
      c['blocks'].each do |b|
        puts filename = build_filename(b, c)
        content = File.read(filename)
        [/id: .*/, /---\n/, /title: .*/].map {|n| content.gsub!(n, '')}
        write '<h2 id="' + b + '">' + titleize(b) + '</h2>'
        write GitHub::Markup.render_s GitHub::Markups::MARKUP_MARKDOWN, content
      end
      write @@presets['section']['end']
    end
    write @@presets['body']['end']

    puts "Done. Wrote to: " + @@config['output']
  end

  private
  def build_filename b, c
    prefix = c['prefix'] ? c['prefix'] + '/' : ''
    @@config['content']['directory'] + prefix + b + @@config['content']['extension']
  end
  def write(content)
    @@output << content
  end
  def titleize(str)
    str.gsub('-',' ').split(' ').each{|c|c.capitalize!}.join(' ')
  end
  def toc
    items = ''
    @@content.each do |c|
      items += '<ul><li><a href="#' + c['title'] + '">' + titleize(c['title']) + '</a></li><ul>'
      c['blocks'].each do |b|
        items += '<li><a href="#' + b + '">' + titleize(b) + '</a></li>'
      end
      items += '</ul></ul>'
    end
    items
  end
end
