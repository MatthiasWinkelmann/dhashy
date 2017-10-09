require "dhashy/version"

class Dhashy
   def initialize(jpg)
      return from_array(jpg) if jpg.class == Array
      jpg.combine_options do |j|
         j.channel_fx "Gray"
         j.resize "9x8!"
      end
      @hash = from_array(jpg.get_pixels.map {|x| x.map(&:first) })
   end
   def -(other)
      (0..7).map {|x| (0..7).map {|y| (@hash[x][y] - other[x][y]).abs}.sum}.sum
   end
   def[](index)
      @hash[index]
   end
   def ==(other)
      self - other < 5
   end

   def display
      @hash.map {|x| x.join() }.join("\n")
   end
   def to_s
      @hash.join()
   end

   def to_i
      (0..7).map {|x| (0..7).map {|y| @hash[x][y] * 2**(x*y)}}.sum
   end
  private

   def from_array(jpg)
      return (0..7).map { |x| (0..7).map { |y|  (jpg[x][y] > jpg[x][y+1]) ? 1 : 0 }}
      end

end
