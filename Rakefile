require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :trials do

   require "mini_magick"
   parameters = {}
   parameters[:resize] = (0..9).map {|x| 100 - x * 10}
   parameters[:stretch] = ["100%", "10%", "25%", "50%", "75%", "133%", "200%", "400%", "1000%"]
   # parameters[:resize_y] = (1..10).map {|x| x * 10}
   parameters[:crop] =  [false, "90%x90%+5%+5%", "50%x50%+25%+25%","90%x10%-1-1", "10%x100%-10%-10%"]
   parameters[:rotate] = (0..7).map {|x| x * 45}
   parameters[:flip] = [false, true]
   parameters[:monochrome] = [false, true]
   parameters[:contrast] = [false, 1, 2, 3]
   parameters[:enhance] = [false, true]
   results = {}
   parameters.each do |key, values|
      results[key] = Hash[values.map {|value| [value.to_s, []]}]
   end

   original = Dhashy.new(MiniMagick::Image.open("test/obama.jpg"))

   parameters.each do |change, choices|
      choices.each do |choice|

      settings = Hash[parameters.map {|parameter, values| [parameter, values.first]}]
      settings[change] = choice
      # settings = Hash[parameters.map {|parameter, values| [parameter, values.sample]}]
      other = MiniMagick::Image.open("test/obama.jpg")
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
      puts "#{t} #{u} #{settings[:resize]}"
      diff = original - Dhashy.new(other)
      parameters.each do |key, values|
         results[key][settings[key].to_s] << diff if key == change
      end
   end
   end
   puts results
   results.each do |modification, options|
      options.keys.sort.each do |option|
         results = options[option]
         next unless results.size > 0
         puts "   %2i %4i %s" % [results.sum / results.size, results.size, option]
      end
   end
end
task :default => :test
