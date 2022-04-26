module AIRAC

  # AIRAC cycle date calculations
  #
  # @example
  #   cycle = AIRAC::Cycle.new('2018-01-01')
  #   cycle.date         # => #<Date: 2017-12-07>
  #   cycle.effective    # => 2017-12-07 00:00:00 UTC..2018-01-03 23:59:59 UTC
  #   cycle.id           # => 1713
  #   (cycle + 5).id     # => 1804
  #   (cycle - 5).id     # => 1708
  #   (cycle - 100).id   # => ArgumentError
  class Cycle
    include Comparable

    # First AIRAC date following the last cycle length modification
    ROOT_DATE = Date.parse('2015-06-25').freeze

    # Length of one AIRAC cycle
    DAYS_PER_CYCLE = 28

    # @return [Date] AIRAC effective on date
    attr_reader :date

    # @return [Integer] AIRAC cycle ID
    attr_reader :id

    # @param raw_cycle [Date, String, nil] either a four digit AIRAC cycle ID
    #   or any date within the AIRAC cycle
    def initialize(raw_cycle=nil)
      if raw_cycle.to_s.match?(/\A\d{4}\z/)
        @id = raw_cycle.to_s
        @date = date_for_id(@id)
      else
        raw_cycle = raw_cycle ? Date.parse(raw_cycle.to_s) : Date.today
        fail(ArgumentError, "cannot calculate dates before #{ROOT_DATE}") if raw_cycle < ROOT_DATE
        @date = date_for_date_within(raw_cycle)
        @id = id_for(@date)
      end
    end

    # @return [String]
    def inspect
      %Q(#<#{self.class} #{id} #{date}>)
    end

    # @param template [String, nil] strftime template with %i for AIRAC cycle
    #   (default: '%i %Y-%m-%d')
    # @return [String]
    def to_s(template=nil)
      date.strftime((template || '%i %Y-%m-%d').sub(/%i/, id))
    end

    # Time range within which this cycle is effective.
    #
    # @return [Range<Time>]
    def effective
      next_date = date + DAYS_PER_CYCLE
      (Time.utc(date.year, date.month, date.day)..(Time.utc(next_date.year, next_date.month, next_date.day) - 1))
    end

    # @param days [Numerical] add this many days
    # @return [AIRAC::Cycle] new object with offset applied
    def +(cycles)
      AIRAC::Cycle.new(@date + cycles * DAYS_PER_CYCLE)
    end

    # @param cycles [Numerical] subtract this many cycles
    # @return [AIRAC::Cycle] new object with offset applied
    def -(cycles)
      self + -cycles
    end

    # @see Object#<=>
    # @return [Integer]
    def <=>(other)
      id <=> other.id
    end

    # @see Object#==
    # @return [Boolean]
    def ==(other)
      self.class === other  && (self <=> other).zero?
    end
    alias_method :eql?, :==

    # @see Object#hash
    # @return [Integer]
    def hash
      to_s.hash
    end

    private

    # Find the AIRAC date for given date within the cycle
    def date_for_date_within(date_within)
      ROOT_DATE + (date_within - ROOT_DATE).to_i / DAYS_PER_CYCLE * DAYS_PER_CYCLE
    end

    # Find the AIRAC date for given cycle ID
    def date_for_id(id)
      year = (Date.today.year.to_s[0,2] + id[0,2]).to_i
      preceding_cycle = self.class.new(Date.parse("#{year}-01-01") - 1)
      (preceding_cycle + id[2,2].to_i).date
    end

    # Find the AIRAC ID for the AIRAC +date+
    def id_for(date)
      '%04d' % ((date.year % 100) * 100 + ((date.yday - 1) / DAYS_PER_CYCLE) + 1)
    end

  end
end
