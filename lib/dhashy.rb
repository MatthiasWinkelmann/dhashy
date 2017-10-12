require "dhashy/version"

# @author Matthias Winkelmann <m@matthi.coffee>
# The *difference hash* is a compact representation
# of an image (i. e. photo) that works well for fuzzy
# finding of pairs of images that are substantially
# euqal.
#
class Dhashy
   attr_reader :size

   def initialize(jpg, size=128)
      self.size = size

      return from_array(jpg) if jpg.is_a? Array
      jpg = MiniMagick::Image.open(jpg.to_s) if jpg.is_a? Pathname
      jpg.combine_options do |j|
         j.channel_fx "Gray"
         j.resize "#{@dimension + 1}x#{@dimension + 1}!"
      end
      gray_pixels = jpg.get_pixels.map {|x| x.map {|y| y.first }}
      @hash = from_array(gray_pixels)
   end

   # Our budget is spent on two square matrices:
   #   one with the differences from row to row
   #   the second with differences from column to column

   def dimension(size)
      Math.sqrt(size / 2).to_i
   end

   def size=(newsize)
      fail "size must be integer" unless newsize.is_a? Integer
      unless 2 * (Math.sqrt(newsize/2)**2) == newsize
         fail "sqrt(size / 2) must be integer. Got #{newsize} with sqrt(#{newsize} / 2) = #{Math.sqrt(newsize / 2)}"
      end
      @size = newsize
      @dimension = self.dimension(size)
   end

   # (Hamming-) Distance, or visual difference
   #
   # @param [DHashy] another hash
   # @return [Integer] The Hamming distance (also Manhattan-distance),
   #    i. e. the number of different bits

   def -(other)
      [0,1].map { |matrix| (0...@dimension).map {|x| (0...@dimension).map {|y| (@hash[matrix][x][y] == other[matrix][x][y]) ? 0 : 1 }.sum}.sum}.sum
   end

   def[](index)
      @hash[index]
   end

   # Visual Equality
   #
   # @oaram [DHashy] another hash
   # @param [cutoff] number of bits allowed to differ.
   #    Default: @size / 64 (i. e. 2 bits for default size)
   # @return [Boolean]
   def ==(other, cutoff=@size / 64)
      self - other < 5
   end

   def display
      (0...@dimension).map {|x|   [0,1].map { |matrix| (0...@dimension).map {|y| @hash[matrix][x][y] ? '1' : '0'}.join }.join(" ")}.join("\n")
   end

   # return [String] The concatenated row- and
   #   column-wise matrices, compatible to the
   #   python implementation
   # @see https://github.com/Jetsetter/dhash
   def matrix
      [0,1].map do |matrix|
         (0...@dimension).map do |x|
            (0...@dimension).map do |y|
               @hash[matrix][x][y] ? '1' : '0'
            end.join
         end.join("\n")
      end.join("\n")
   end

   def to_s
      [0,1].map do |matrix|
         (0...@dimension).map do |x|
            (0...@dimension).map do |y|
               @hash[matrix][x][y] ? '1' : '0'
            end.join
         end.join
      end.join
   end

   # return [Integer] The integer of bit length
   #    <size> representing the hash
   def to_i
      [0,1].map do |matrix|
         (0...@dimension).map do |x|
            (0...@dimension).map do |y|
               @hash[x][y] * 2**(x*y)
            end
         end
      end
      .sum
   end

   private

   def from_array(jpg)
      [
         (0...@dimension).map { |x| (0...@dimension).map { |y| (jpg[y][x] <= jpg[y][x+1] ) }},
         (0...@dimension).map { |x| (0...@dimension).map { |y| (jpg[y][x] <= jpg[y+1][x]) }}
      ]
   end
end
