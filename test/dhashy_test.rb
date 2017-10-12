require "test_helper"
require "dhashy"

class DhashyTest < Minitest::Test
   def setup
      @jpg = load_jpg
   end

   def test_that_it_has_a_version_number
      refute_nil ::Dhashy::VERSION
   end

   def test_validation_of_size_parameter
      (["\"a string\"", false, true, 1.1, -4.1, Class, 0, 1, 3] + (5..7).to_a + (9..15).to_a + (17..31).to_a).each do |wrongsize|
         assert_throws(Exception,"#{wrongsize} as size should trigger exeption, but didn't") { Dhashy.new(@jpg, wrongsize) }
      end
   end


   def test_length_128
      hash = Dhashy.new(@jpg).to_s
      assert_match(/^[01]{128}$/,  hash, "Length of hash is #{hash.length}, not 128")
   end


   def test_length_98
      hash = Dhashy.new(@jpg, 98).to_s
      assert_match(/^[01]{98}$/,  hash, "Length of hash is #{hash.length}, not 98")
   end

   def test_length_72
      hash = Dhashy.new(@jpg, 72).to_s
      assert_match(/^[01]{72}$/,  hash, "Length of hash is #{hash.length}, not 72")
   end

   def test_length_50
      hash = Dhashy.new(@jpg, 50).to_s
      assert_match(/^[01]{50}$/,  hash, "Length of hash is #{hash.length}, not 50")
   end

   def test_length_32
      hash = Dhashy.new(@jpg, 32).to_s
      assert_match(/^[01]{32}$/,  hash, "Length of hash is #{hash.length}, not 32")
   end

   def test_length_18
      hash = Dhashy.new(@jpg, 18).to_s
      assert_match(/^[01]{18}$/,  hash, "Length of hash is #{hash.length}, not 18")
   end
   def test_length_8
      hash = Dhashy.new(@jpg, 8).to_s
      assert_match(/^[01]{8}$/,  hash, "Length of hash is #{hash.length}, not 8")
   end
   def test_no_difference
      assert (Dhashy.new(@jpg) - Dhashy.new(@jpg)) < 2
   end

   def test_difference
      other = load_jpg.combine_options do |j|
         j.rotate "90"
         # j.flip
      end

      newhash = Dhashy.new(other)

      otherhash = Dhashy.new(other)
      diff = newhash - otherhash
      assert diff > 20, "Difference is #{diff} \n\n#{otherhash.display}\n\n#{newhash.display}"
   end

   def test_equality
      assert_equal true, Dhashy.new(@jpg) == Dhashy.new(@jpg)
   end

   def test_same_matrix_as_python
      reference = `test/reference.py test/test.jpg`[/<matrix>(.*)<\/matrix>/m,1]
      assert_equal reference, Dhashy.new(@jpg,8).matrix
   end

   # def test_string_representation
   #    assert_equal "00000001110010100010111101011111010111101000100111110000000000111101011100000111001000100001011000", Dhashy.new(@jpg).to_s
   # end

   def load_jpg
      MiniMagick::Image.open("test/test.jpg")
   end
end
