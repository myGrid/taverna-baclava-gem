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

class TestBaclava < Test::Unit::TestCase
  SINGLE_IN = []
  MANY_IN =   [[["boo"]], [["", "Hello"]], [], [[], ["test"], []]]
  MAP =       {
    "SINGLE_IN" => Taverna::Baclava::Node.new(SINGLE_IN),
    "MANY_IN" => Taverna::Baclava::Node.new(MANY_IN)
  }

  def test_reader
    input = Taverna::Baclava::Reader.read(File.read("test/test.baclava"))
    assert_equal(input, MAP)
    map = Taverna::Baclava::Node.extract_node_data(input)
    assert_equal(map["SINGLE_IN"], SINGLE_IN)
    assert_equal(map["MANY_IN"], MANY_IN)
  end

  def test_writer
    input = Taverna::Baclava::Reader.read(Taverna::Baclava::Writer.write(MAP))
    assert_equal(input, MAP)
    map = Taverna::Baclava::Node.extract_node_data(input)
    assert_equal(map["SINGLE_IN"], SINGLE_IN)
    assert_equal(map["MANY_IN"], MANY_IN)
  end
end
