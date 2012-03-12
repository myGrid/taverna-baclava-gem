# Copyright (c) 2006-2012 The University of Manchester, UK.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#  * Neither the names of The University of Manchester nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# Authors: Robert Haines, Stian Soiland-Reyes, David Withers, Emmanuel Tagarira

require 'baclava/node'
require 'rexml/document'

module Taverna
  module Baclava

    class Reader

      # Reads a baclava document and returns a hash of Baclava::Node objects.
      def self.read(xml)
        if xml.kind_of?(REXML::Document)
          document = xml
        else
          document = REXML::Document.new(xml)
        end
        root = document.root
        raise "'#{root.name}' doesn't appear to be a data thing!" if root.name != "dataThingMap"

        create_data_map(root)
      end

      # :stopdoc:

      def self.create_data_map(element)
        data_map = {}

        element.each_element('b:dataThing') do |datathing|
          key = datathing.attribute('key').value
          data = Node.new
          data_map[key] = data
          datathing.each_element('b:myGridDataDocument')  do |dataDocument|
            dataDocument.each_element('s:metadata') do |metadata|
              data.annotation = get_metadata(metadata)
            end
            dataDocument.each_element('b:partialOrder') do |partialOrder|
              data.value = get_list(partialOrder)
            end
            dataDocument.each_element('b:dataElement') do |dataElement|
              data.value = get_element(dataElement)
            end
          end
        end

        data_map
      end

      def self.get_list(element)
        list = []
        element.each_element('b:itemList') do |itemList|
          itemList.each_element('b:dataElement') do |dataElement|
            list << get_element(dataElement)
          end
          itemList.each_element('b:partialOrder') do |partialOrder|
            list << get_list(partialOrder)
          end
        end
        list
      end

      def self.get_metadata(element)
        list = []
        element.each_element('s:mimeTypes') do |mimeTypes|
          mimeTypes.each_element('s:mimeType') do |mimeType|
            list << mimeType.text
          end
        end
        list
      end

      def self.get_element(element)
        element.each_element('b:dataElementData') do |data|
          text = data.text
          return text.nil? ? "" : Base64.decode64(text)
        end
      end
    end
  end
end
