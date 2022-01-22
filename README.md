[![Version](https://img.shields.io/gem/v/airac.svg?style=flat)](https://rubygems.org/gems/airac)
[![Tests](https://img.shields.io/github/workflow/status/svoop/airac/Test.svg?style=flat&label=tests)](https://github.com/svoop/airac/actions?workflow=Test)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/svoop/airac.svg?style=flat)](https://codeclimate.com/github/svoop/airac/)
[![Donorbox](https://img.shields.io/badge/donate-on_donorbox-yellow.svg)](https://donorbox.org/bitcetera)

# AIRAC

[AIRAC cycle](https://en.wikipedia.org/wiki/Aeronautical_Information_Publication) calculations for Ruby.

* [Homepage](https://github.com/svoop/airac)
* [API](https://www.rubydoc.info/gems/airac)
* Author: [Sven Schwyn - Bitcetera](https://bitcetera.com)

## Install

### Security

This gem is [cryptographically signed](https://guides.rubygems.org/security/#using-gems) in order to assure it hasn't been tampered with. Unless already done, please add the author's public key as a trusted certificate now:

```
gem cert --add <(curl -Ls https://raw.github.com/svoop/airac/main/certs/svoop.pem)
```

### Bundler

Add the following to the <tt>Gemfile</tt> or <tt>gems.rb</tt> of your [Bundler](https://bundler.io) powered Ruby project:

```ruby
gem airac
```

And then install the bundle:

```
bundle install --trust-policy MediumSecurity
```

## Usage

You can use this gem in your Ruby project:

```ruby
airac = AIPP::AIRAC.new('2018-01-01')
airac.date        # => #<Date: 2017-12-07 ((2458095j,0s,0n),+0s,2299161j)>
airac.id          # => 1713
airac.next_date   # => #<Date: 2018-01-04 ((2458123j,0s,0n),+0s,2299161j)>
airac.next_id     # => 1801
```

Or use the `airac` executable:

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
