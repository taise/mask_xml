#! ruby
# coding: utf-8
# $KCODE = 'u' #=> use ruby1.8.7
#
# Masking each tag in the XML data
#  - specifies some masking tags in YAML file
# 
# todo
#  - check the xPath read from yaml file
#  - display the correct error message to specify the xPath

require 'rexml/document'
require 'yaml'

class MaskXml
  include REXML

  def initialize
    get_argv
    @doc  = REXML::Document.new File.new(@xml_file)
    @yaml = YAML.load(File.read(@yaml_file))
  end

  # get xml & yaml file path from ARGV
  def get_argv
    begin
      @xml_file  = ARGV.detect {|arg| /.+\.xml/ =~ arg }
      @yaml_file = ARGV.detect {|arg| /.+\.ya?ml/ =~ arg }
      raise unless @xml_file && @yaml_file
    rescue
      raise ArgumentError, "expected two arguments : xml & yaml"
    end 
  end

  # replace with a skip character
  def skip_char(text)
    mask_text = ""
    size = text.size
    i = 0
    while i < size
      mask_text += (text[i] + "*")
      i += 2
    end
    mask_text
  end

  # read string replace mode from the YAML
  # default mode: Replace the "*" character minute
  #
  def set_mask_text_by_mode(text)
    mask_mode = @yaml['mask_mode']
    case mask_mode
    when "skip_char" 
      mask_text = skip_char(text)
    else
      mask_text = "*" * text.size
    end
  end

  def replace_tag(mask_tag)
    parent_tag_path = mask_tag[0]
    mask_tag_name   = mask_tag[1]
    mask_text = ""

    # when mask_tag length is 2,
    # read string replacement mode from YAMLfile
    if mask_tag.size > 2
      mask_text = mask_tag[2]
    else
      text = @doc.elements[parent_tag_path + mask_tag_name].text
      mask_text = set_mask_text_by_mode(text)
    end

    # must refactoring
    parent_doc = @doc.root.elements[parent_tag_path]
    old_child = @doc.elements[parent_tag_path + mask_tag_name]
    new_child = REXML::Element.new(mask_tag_name).add_text(mask_text)
    parent_doc.replace_child(old_child, new_child)
  end

  def mask_element
    @yaml['mask_tags'].each {|mask_tag|
      replace_tag(mask_tag)
    }
  end

  def xml_file_output
    f = open("masked_#{@xml_file}", "w")
    f.print @doc
  end

  def doc_output
    @yaml['mask_tags'].each {|mask_tag|
      parent_tag_path = mask_tag[0]
      puts "# mask_tag : #{mask_tag[1]}"
      puts @doc.elements[parent_tag_path]
      puts ""
    }
    puts "# masked xml"
    puts @doc
  end
end

if $0 == __FILE__
  mask_xml = MaskXml.new
  mask_xml.mask_element
  mask_xml.doc_output
  mask_xml.xml_file_output
end
