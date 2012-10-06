#! ruby
# coding: utf-8

require 'rexml/document'
require 'yaml'

class MaskXml
  include REXML
  def xmlfile_to_DOM(path)
    doc = REXML::Document.new File.new(path)
  end

  def get_yaml(yaml)
    yaml_data = YAML.load(File.read(yaml))
    puts yaml_data
    yaml_data
  end

  def get_replace_tags(yaml_data)
    replace_tags = yaml_data['replace_tags']
    p replace_tags
    replace_tags
  end

  def data_mask(doc, replace_tags)
    parent_tag = replace_tags[0][0]
    tag_name   = replace_tags[0][1]
    parent_doc = doc.root.elements[parent_tag]
    old_child = doc.elements[parent_tag + tag_name]
    new_child = REXML::Element.new(tag_name).add_text("***********")
    puts parent_doc.replace_child(old_child, new_child)
  end
end

mask_xml = MaskXml.new
doc = mask_xml.xmlfile_to_DOM("syuto.xml")
yaml_data = mask_xml.get_yaml("tags.yaml")
replace_tags = mask_xml.get_replace_tags(yaml_data)
mask_xml.data_mask(doc, replace_tags)

#tag = '/MD_Metadata/identificationInfo/MD_DataIdentification/citation/title'
#parent_tag = '/MD_Metadata/identificationInfo/MD_DataIdentification/citation'

# 対象となるエレメントのテキスト・ノードを置換する
# 子要素の置換はreplace_child(newChild, oldChild)メソッドを使用する
#
#n = doc.root.elements[parent_tag]
#puts "node:     #{n}"
#old_child = doc.elements[tag]
#puts "old_child: #{old_child}" 
#tag_name = old_child.name
#puts "tag_name : #{tag_name}"
#new_child = REXML::Element.new(tag_name).add_text("********")
#puts "new_child: #{new_child}"
#n.replace_child(old_child, new_child)
#puts doc.elements[parent_tag]
