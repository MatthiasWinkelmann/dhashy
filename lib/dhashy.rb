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
         j.resize "#{@dimension + 1}x#{@dimension + 1}!"
      end
      @pixels = jpg.get_pixels.map {|row| row.map {|p| ((p[0].to_f * 299) + (p[1] * 587) + (p[2] * 114)).to_f / 1000.0  }}
      @h = from_array(@pixels)
   end

   # Our budget is spent on two square matrices:
   #   one with the differences from row to row
   #   the second with differences from column to column

   def dimension(size)
      Math.sqrt(size / 2).to_i
   end

   def size=(newsize)
      fail(ArgumentError, "size must be integer, got %s: %s" % [newsize, newsize.class]) unless newsize.is_a?(Numeric) 
      fail(ArgumentError, "size must be integer, got %s: %s" % [newsize, newsize.class]) unless newsize.integer?
      fail(ArgumentError, "size must be >= 4") unless newsize >= 4 
      if self.dimension(newsize) !=  Math.sqrt(newsize / 2.0)
        fail(ArgumentError, "sqrt(size / 2) must be integer, is sqrt(%s / 2) / 2 = %s" % [newsize, self.dimension(newsize)]) 
      end
      @size = newsize
      @dimension = self.dimension(@size)
   end

   # (Hamming-) Distance, or visual difference
   #
   # @param [DHashy] another hash
   # @return [Integer] The Hamming distance (also Manhattan-distance),
   #    i. e. the number of different bits

   def -(other)
      [0,1].map { |matrix| (0...@dimension).map {|x| (0...@dimension).map {|y| (@h[matrix][x][y] == other[matrix][x][y]) ? 0 : 1 }.sum}.sum}.sum
   end

   def[](index)
      @h[index]
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

   def display(values = nil)
    values = @h unless values
      [1,0].map do |matrix|
        (0...@dimension).map do |x|
            (0...@dimension).map do |y| 
              values[matrix][x][y]  ? '*' : '.'
            end.join(" ")
        end.join("\n")
      end.join("\n\n") + "\n"
   end

   # return [String] The concatenated row- and
   #   column-wise matrices, compatible to the
   #   python implementation
   # @see https://github.com/Jetsetter/dhash
   def matrix
      [0,1].map do |matrix|
         (0...@dimension).map do |x|
            (0...@dimension).map do |y|
               @h[matrix][x][y] ? '1' : '0'
            end.join
         end.join("\n")
      end.join("\n")
   end

   def to_s
      [0,1].map do |matrix|
         (0...@dimension).map do |x|
            (0...@dimension).map do |y|
               @h[matrix][x][y] ? 1 : 0
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
               @h[x][y] * 2**(x*y)
            end
         end
      end
      .sum
   end
   
   private
   def from_array(gray)
    [:rows, :cols].map do |direction| 
        (0...@dimension).map do |y| 
          (0...@dimension).map do |x|
            if direction == :rows
              gray[x][y] <= gray[x+1][y]
            else
              gray[x][y] <= gray[x][y+1]
            end
          end
        end
      end
   end
end
