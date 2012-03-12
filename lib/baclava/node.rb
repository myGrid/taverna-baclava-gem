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

module Taverna
  module Baclava

    # An annotated data value.
    class Node

      # The value of this Node.
      attr_reader :value

      # A list of annotations on this Node.
      attr_accessor :annotation

      # The syntactic type of this node.
      attr_reader :syntactic_type

      # Create a new Node. If a list is passed in as the value then it is
      # recursively processed into a list of Nodes.
      def initialize(value = nil, annotation = [])
        @syntactic_type = ""
        @value = value.nil? ? nil : _set_value(value)
        @annotation = annotation
      end

      # Set the value of this Node. If a list is passed in then it is
      # recursively processed into a list of Nodes.
      def value=(value)
        @value = value.nil? ? nil : _set_value(value)
      end

      # Test for equality between this and another Node.
      def ==(other)
        @value == other.value and @annotation == other.annotation
      end

      # Extract the data value(s) from this Node and return them in the same
      # structure as the given Node.
      def Node.extract_node_data(node)
        case node
        when Hash
          hash = {}
          node.each { |k, v| hash[k] = Node.extract_node_data(v.value) }
          hash
        when Array
          list = []
          node.each { |n| list << Node.extract_node_data(n.value) }
          list
        when Taverna::Baclava::Node
          Node.extract_node_data(node.value)
        else
          node
        end
      end

      private

      # Recursively set the value of this node, creating the underlying lists
      # if necessary.
      def _set_value(value)
        if value.is_a? Array
          value.map do |v|
            v.is_a?(Taverna::Baclava::Node) ? v : Node.new(v)
          end
        else
          value.to_s
        end
      end

    end
  end
end
