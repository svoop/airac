gem 'minitest'

require 'pathname'

require 'minitest/autorun'
require Pathname(__dir__).join('..', 'lib', 'airac')

require 'minitest/flash'
require 'minitest/focus'

class Minitest::Spec
  class << self
    alias_method :context, :describe
  end
end
