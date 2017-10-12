require "bundler/gem_tasks"
require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :tree do |t|
   require '../minimagick/lib/mini_magick'
   require './lib/dhashy'

   results = []
   (0..9).each do |folder|
      ff = "../chill/data/images/004/%03i/???/1.jpg" % folder
      puts ff
      Pathname.glob(ff).combination(2).to_a.shuffle.each do |first, second|
         puts "#{first} #{second}"
         f1 = Dhashy.new(first)
         f2 = Dhashy.new(second)
         diff = f1 - f2
         results << diff
         puts "difference %2i avg %2i" % [diff, results.sum / results.size]
      end
   end
end

task :trials do |t|

   require "mini_magick"
   require './lib/dhashy'
   parameters = {}
   parameters[:resize] = (0..9).map {|x| 100 - x * 10}
   parameters[:stretch] = ["100%", "10%", "25%", "50%", "75%", "133%", "200%", "400%", "1000%"]
   # parameters[:resize_y] = (1..10).map {|x| x * 10}
   #parameters[:crop] =  [false, "90%x90%+5%+5%", "50%x50%+25%+25%","90%x10%-1-1", "10%x100%-10%-10%"]
   parameters[:rotate] = (0..7).map {|x| x * 45}
   parameters[:flip] = [false, true]
   parameters[:monochrome] = [false, true]
   parameters[:contrast] = [false, 1, 2, 3]
   parameters[:enhance] = [false, true]
   results = {}
   parameters.each do |key, values|
      results[key] = Hash[values.map {|value| [value.to_s, []]}]
   end
   original = Dhashy.new(MiniMagick::Image.open("test/test.jpg"), 128)

   parameters.each do |change, choices|
      choices.each do |choice|

         settings = Hash[parameters.map {|parameter, values| [parameter, values.first]}]
         settings[change] = choice
         other = MiniMagick::Image.open("test/test.jpg")
         t = other.get_pixels.size
         other.combine_options do |image|
            image.resize "#{settings[:resize]}%x#{settings[:stretch]}!"
            image.rotate settings[:rotate]
            image.flip if settings[:flip]
            image.crop settings[:crop] if settings[:crop]
            settings[:contrast].times { image.contrast } if settings[:contrast]
            image.enhance if settings[:enhance]
            image.monochrome if settings[:monochrome]
         end

         u = other.get_pixels.size
         otherhash = Dhashy.new(other)
         puts "original"
         puts original.display
         puts "other"
         puts otherhash.display
         diff = original - otherhash
         puts "diff: #{diff}"
         parameters.each do |key, values|
            results[key][settings[key].to_s] << diff if key == change
         end
      end
   end

   results.each do |modification, options|
      puts modification
      options.keys.sort.each do |option|
         thisresult = options[option]
         next unless thisresult.size > 0
         puts "   %2i %4i %s" % [thisresult.sum / thisresult.size, thisresult.size, option]
      end
   end
end

task :default => :test
