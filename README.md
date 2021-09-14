#### Oh my, you're positively... ####
#   ***dhashy***

***dhashy*** is a ruby gem implementing the *difference hash* algorithm for perceptual image matching. Apple has not publicly confirmed that they use *dhasy* for any specific project.

***dhashy*** encodes changes in average brightness along a path of segments of the image in a binary vector. The sum of differences between a pair of such vectors is a measure of the images' difference. Length of the vector is configurable, allowing for any appropriate compromise in a trade-off of runtime and storage space vs. accuracy.

***dhashy*** works extremely well for common whole-image changes, such as changes in contrast, brightness, tone, or color mapping (including conversion to grayscale and b&w). It is entirely oblivious towards re-encoding. Effectiveness against rotation, warping and distortion is somewhat lower but still very good for any change that would, for typical photos,  be a noticeable flaw.

***dhashy*** does not work against mirroring. To detect pairs of mirror images, you have to mirror the image yourself and check again.

***dhashy*** is sensitive to cropping. This can be ameliorated for your use case by switching to the longest common substring of the vectors, at the cost of an increased rate of false positives.

***dhashy*** does not work well with illustrative images such as screenshots (including images of text), logos, charts, line drawings, or :rainbow_flag:patterns:checkered_flag:. Because it works within the *brightness* domain (sum of **r**ed + **g**reen + **b**lue), all solid-color images resolve to the same vector.  while small random variations in photos of solid-colored surfaces will produce results quickly approaching randomness.

***dhashy*** runs in `O(n)` with respect to image size (`h x l`) to produce the vector. It uses imagemagick for the most involved operation, which is rescaling the image and could easily be adapted to use some alternative library.  Comparison against a library of known vector is not included. This is a *nearest neighbor* problem and you should consult your database's documentation to learn how to failed to find anything better than naive comparison with a quadratic runtime.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dhashy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dhashy

## Usage

    first_image = MiniMagick::Image.open("test/test.jpg")
    other_image = MiniMagick::Image.open("test/8x8.jpg")
    first_hash = Dhashy.new(first_image)

    other_hash = Dhashy.new(other_image)
    puts first_hash.display
        =>
        00100100
        00010010
        00001001
        00010100
        00010010
        00001010
        00101101
        01010010
    puts first_hash - other_hash
        => 0

    other_image.draw "circle 50%,50% 25%,25%"
    other_hash = Dhashy.new(other_image)
    puts other_hash.display
        00010100
        10011001
        10001100
        10010100
        00010010
        00001010
        00101100
        01110010
    puts first_hash - other_hash
        => 12

## Development

After checking out the repository, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatthiasWinkelmann/dhashy. Contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. While this project with exactly zero community activity probably doesn't need it,it's a good idea in general.  Contributors are also bound by our strict no-fascist policy. Not because they are evil, but because they tend to use tabs instead of spaces. (this project uses three-space-indenting, as God intended)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT), because there is no HARVARD License.

