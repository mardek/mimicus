# Mimicus

Monitoring Solution, Cloud Oriented based on Ruby and Redis for GNU/Linux distros

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mimicus'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mimicus

## Usage

1. Install ruby
```
    dnf install ruby
```
2. Install rake
```
    gem install rake
```
3. fetch the mimicus sources
```
    git clone https://github.com/mardek/mimicus
```
4. Build the mimicus agent
```
    cd mimicus && rake
    gem install pkg/mimicus-version.gem
```
## Contributing

1. Fork it ( https://github.com/mardek/mimicus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
