[![Version](https://img.shields.io/gem/v/airac.svg?style=flat)](https://rubygems.org/gems/airac)
[![Tests](https://img.shields.io/github/actions/workflow/status/svoop/airac/test.yml?style=flat&label=tests)](https://github.com/svoop/airac/actions?workflow=Test)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/svoop/airac.svg?style=flat)](https://codeclimate.com/github/svoop/airac/)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/svoop.svg)](https://github.com/sponsors/svoop)

# AIRAC

[AIRAC (Aeronautical Information Regulation And Control)](https://en.wikipedia.org/wiki/Aeronautical_Information_Publication) cycle calculations for Ruby.

* [Homepage](https://github.com/svoop/airac)
* [API](https://www.rubydoc.info/gems/airac)
* Author: [Sven Schwyn - Bitcetera](https://bitcetera.com)

Thank you for supporting free and open-source software by sponsoring on [GitHub](https://github.com/sponsors/svoop) or on [Donorbox](https://donorbox.com/bitcetera). Any gesture is appreciated, from a single Euro for a ☕️ cup of coffee to 🍹 early retirement.

## Install

Add the following to the <tt>Gemfile</tt> or <tt>gems.rb</tt> of your [Bundler](https://bundler.io) powered Ruby project:

```ruby
gem 'airac'
```

And then install the bundle:

```
bundle install
```

## Usage

You can use this gem in your Ruby project:

```ruby
cycle = AIRAC::Cycle.new('2018-01-01')
cycle.date         # => #<Date: 2017-12-07>
cycle.effective    # => 2017-12-07 00:00:00 UTC..2018-01-03 23:59:59 UTC
cycle.id           # => 1713
(cycle + 5).id     # => 1804
(cycle - 5).id     # => 1708
```

The cycle can be formatted similar to `Date#strftime`, however, the placeholder `%i` represents the AIRAC cycle ID:

```ruby
cycle = AIRAC::Cycle.new('2018-01-01')
cycle.to_s                            # "1713 2017-12-07"
cycle.to_s("@%i as per %b %-d, %Y")   # => "@1713 as per Dec 7, 2017"
```

The current AIRAC cycle scheme started on 2015-06-25, therefore any calculation which leads to dates prior to inception will cause an error:

```ruby
(cycle - 100).id   # => ArgumentError
```

The `AIRAC::Cycle` class implements `Comparable` and its instances can safely be used s `Hash` keys.

If you prefer to do the math on the shell, the `airac` executable is your friend:

```shell
airac --help
```

## Development

To install the development dependencies and then run the test suite:

```
bundle install
bundle exec rake    # run tests once
bundle exec guard   # run tests whenever files are modified
```

You're welcome to [submit issues](https://github.com/svoop/airac/issues) and contribute code by [forking the project and submitting pull requests](https://docs.github.com/en/get-started/quickstart/fork-a-repo).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
