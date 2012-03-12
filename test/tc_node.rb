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
# Author: Robert Haines

class TestNode < Test::Unit::TestCase
  TEST_VALUE = "Hello"
  TEST_LIST = ["Hello", "World!"]
  TEST_NUMBER = 1337

  def test_singleton
    node = Taverna::Baclava::Node.new(TEST_VALUE)
    assert_equal(node.value, TEST_VALUE)
    assert_equal(node.annotation, [])
  end

  def test_lists
    node = Taverna::Baclava::Node.new(TEST_LIST)
    assert_equal(node.value[0].value, TEST_LIST[0])
    assert_equal(node.value[1].value, TEST_LIST[1])
    assert_equal(node.annotation, [])
  end

  def test_non_strings
    node = Taverna::Baclava::Node.new(TEST_NUMBER)
    assert_equal(node.value, TEST_NUMBER.to_s)
    assert_equal(node.annotation, [])
  end

  def test_extract
    n1 = Taverna::Baclava::Node.new(TEST_VALUE)
    n2 = Taverna::Baclava::Node.new(TEST_LIST)
    n3 = Taverna::Baclava::Node.new(TEST_NUMBER)
    map = {
      "value"  => n1,
      "list"   => n2,
      "number" => n3
    }

    assert_equal(Taverna::Baclava::Node.extract_node_data(n1), TEST_VALUE)
    assert_equal(Taverna::Baclava::Node.extract_node_data(n2), TEST_LIST)
    assert_equal(Taverna::Baclava::Node.extract_node_data(n3),
      TEST_NUMBER.to_s)

    map_x = Taverna::Baclava::Node.extract_node_data(map)
    assert_equal(map_x["list"], TEST_LIST)
  end
end
