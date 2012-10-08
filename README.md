# Mask XML

Mask XML is a script that masking the specific information of XML data.
Specifies some masking tags in YAML file.

## How To Use It

1.Clone Mask XML at the command prompt if you haven't yet:

`git clone git@github.com:taise/mask_xml.git`

2.At the command prompt, make a masked xmlfile:

`cd mask_xml/`

`ruby mask_xml.rb samples/sample.xml samples/tags.yaml`


3.When you use this script

  Specify one by one YAML file and XML file at run time.
  YAML file lists the data that you want to mask.'
