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
require 'base64'
require 'rexml/document'
require 'rubygems'
require 'builder'

module Taverna
  module Baclava

    class Writer

      # Write a hash of Baclava::Node objects into a REXML::Document.
      def self.write_doc(data_map)
        REXML::Document.new(write(data_map))
      end

      # Write a hash of Baclava::Node objects into a XML String.
      def self.write(data_map)
        xml = Builder::XmlMarkup.new :indent => 2
        xml.instruct!
        xml.b :dataThingMap, 'xmlns:b' => 'http://org.embl.ebi.escience/baclava/0.1alpha' do
          data_map.each_key do |key|
            data = data_map[key]
            xml.b :dataThing, 'key' => key do
              xml.b :myGridDataDocument, 'lsid' => '', 'syntactictype' => data.syntactic_type do
                write_metadata xml, data.annotation unless data.annotation.nil?
                write_data xml, data.value
              end
            end
          end
        end
      end

      # :stopdoc:

      def self.write_metadata(xml, metadata)
        xml.s :metadata, 'xmlns:s' => 'http://org.embl.ebi.escience/xscufl/0.1alpha' do
          return if metadata.empty?
          xml.s :mimeTypes do
            metadata.each do |mimetype|
              xml.s :mimetype, mimetype.chomp
            end
          end
        end
      end

      def self.write_data(xml, data, index = nil)
        if data.is_a? Array
          write_list xml, data, index
        else
          if index
            xml.b :dataElement, 'lsid' => '', 'index' => index do |x|
              x.b :dataElementData, Base64.encode64(data).chomp
            end
          else
            xml.b :dataElement, 'lsid' => '' do |x|
              x.b :dataElementData, Base64.encode64(data).chomp
            end
          end
        end
      end

      def self.write_list(xml, list, index)
        if index
          xml.b :partialOrder, 'lsid' => '', 'type' => 'list', 'index' => index do
            write_item_list xml, list
          end
        else
          xml.b :partialOrder, 'lsid' => '', 'type' => 'list' do
            write_item_list xml, list
          end
        end
      end

      def self.write_item_list(xml, list)
        xml.b :relationList do
          (1...list.length).each do |i|
            xml.b :relation, 'parent' => (i - 1), 'child' => i
          end
        end
        xml.b :itemList do
          (0...list.length).each do |i|
            write_data xml, list[i].value, i
          end
        end
      end
    end
  end
end
