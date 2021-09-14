# Dhashy

Dhashy is a ruby gem implementing the *difference hash* algorithm for perceptual image matching.
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

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatthiasWinkelmann/dhashy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. While this project with exactly zero community activity probably doesn't need it,it's a good idea in general.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

