require "test_helper"
require "dhashy"

class DhashyTest < Minitest::Test
  def setup
   @jpg = load_jpg
  end

  def test_that_it_has_a_version_number
    refute_nil ::Dhashy::VERSION
  end

  def test_no_difference
   assert (Dhashy.new(@jpg) - Dhashy.new(@jpg)) < 2
  end

  def test_difference
   other = load_jpg.combine_options do |j|
      j.rotate "-90"
      j.flip
   end
   assert Dhashy.new(@jpg) - Dhashy.new(other) > 20
  end

  def test_equality
   assert_equal true, Dhashy.new(@jpg) == Dhashy.new(@jpg)
  end

  def test_string_representation
   assert_equal "0010010000010010000010010001010000010010000010100010110101010010", Dhashy.new(@jpg).to_s
  end

  def load_jpg
   MiniMagick::Image.open("test/obama.jpg")
  end
end
