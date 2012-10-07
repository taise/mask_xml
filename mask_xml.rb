#! ruby
# coding: utf-8
#
# XMLデータをマスク化するスクリプト
#
# 対象のタグのxPathをYAMLファイルで作成しマスク化する。
# マスクのモード
#  1.マスク化文字内容をYAMLファイルから指定する(未実装)
#  2.n文字間隔で記号に置き換える(未実装)
# 

require 'rexml/document'
require 'yaml'

class MaskXml
  include REXML

  def initialize(xml_file, yaml)
    @doc  = REXML::Document.new File.new(xml_file)
    @yaml = YAML.load(File.read(yaml))
  end

  # 対象となるエレメントのテキスト・ノードを置換する
  # 子要素の置換はreplace_child(newChild, oldChild)メソッドを使用する
  def replace_tag(mask_tag)
    parent_tag_path = mask_tag[0]
    mask_tag_name   = mask_tag[1]
    mask_text       = mask_tag[2]

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
  mask_xml = MaskXml.new("syuto.xml", "tags.yaml")
  mask_xml.mask_element
  mask_xml.doc_out
end
