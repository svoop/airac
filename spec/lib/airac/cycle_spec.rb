require_relative '../../spec_helper'

describe AIRAC::Cycle do
  subject { AIRAC::Cycle.new('2018-01-04') }

  describe :initialize do
    it "won't accept invalid arguments" do
      _{ AIRAC::Cycle.new(0) }.must_raise ArgumentError
      _{ AIRAC::Cycle.new(AIRAC::Cycle::ROOT_DATE - 1) }.must_raise ArgumentError
    end

    it "accepts four digit AIRAC cycle IDs" do
      subject = AIRAC::Cycle.new('1801')
      _(subject.id).must_equal "1801"
      _(subject.date.to_s).must_equal "2018-01-04"
    end

    it "accepts parsable dates as String" do
      subject = AIRAC::Cycle.new('2018-01-04')
      _(subject.id).must_equal "1801"
      _(subject.date.to_s).must_equal "2018-01-04"
    end

    it "accepts Date objects" do
      subject = AIRAC::Cycle.new(Date.parse('2018-01-04'))
      _(subject.id).must_equal "1801"
      _(subject.date.to_s).must_equal "2018-01-04"
    end
  end

  describe :id do
    it "calculates the cycle correctly" do
      _(AIRAC::Cycle.new('2018-01-03').id).must_equal '1713'
      _(AIRAC::Cycle.new('2018-01-04').id).must_equal '1801'
      _(AIRAC::Cycle.new('2018-01-05').id).must_equal '1801'
      _(AIRAC::Cycle.new('2020-12-31').id).must_equal '2014'
    end

    it "zero-pads the ID to four digits length" do
      _(AIRAC::Cycle.new('2103-03-08').id).must_equal '0303'
    end

    it "rolls over at the end of the century" do
      _(AIRAC::Cycle.new('2099-12-15').id).must_equal '9912'
      _(AIRAC::Cycle.new('2100-01-14').id).must_equal '0001'
    end
  end

  describe :date do
    it "calculates the cycle date correctly" do
      _(AIRAC::Cycle.new('2018-01-03').date).must_equal Date.parse('2017-12-07')
      _(AIRAC::Cycle.new('2018-01-04').date).must_equal Date.parse('2018-01-04')
      _(AIRAC::Cycle.new('2018-01-05').date).must_equal Date.parse('2018-01-04')
      _(AIRAC::Cycle.new('2020-12-31').date).must_equal Date.parse('2020-12-31')
    end

  end

  describe :to_s do
    it 'returns "iiii YYYY-mm-dd" by default' do
      _(subject.to_s).must_equal '1801 2018-01-04'
    end

    it "returns representation according to template" do
      _(subject.to_s("@%i as per %b %-d, %Y")).must_equal "@1801 as per Jan 4, 2018"
    end
  end

  describe :+ do
    it "adds 1 cycle" do
      _((subject + 1).id).must_equal '1802'
    end

    it "adds 10 cycles" do
      _((subject + 10).id).must_equal '1811'
    end
  end

  describe :- do
    it "subtracts 1 cycle" do
      _((subject - 1).id).must_equal '1713'
    end

    it "subtracts 10 cycles" do
      _((subject - 10).id).must_equal '1704'
    end

    it "failse to subtract beyond the root date" do
      _{ subject - 100 }.must_raise ArgumentError
    end
  end

  describe :<=> do
    let(:before) { subject - 1 }
    let(:after)  { subject + 1 }

    it "calculates order position correctly" do
      _((subject - 1) < subject).must_equal true
      _((subject - 1) > subject).must_equal false
      _((subject + 1) < subject).must_equal false
      _((subject + 1) > subject).must_equal true
    end

    it "correctly sorts an array of AIRAC cycles" do
      cycles = [
        AIRAC::Cycle.new('2023-01-01'),
        AIRAC::Cycle.new('2021-01-01'),
        AIRAC::Cycle.new('2024-01-01'),
        AIRAC::Cycle.new('2022-01-01')
      ]
      _(cycles.sort.map(&:id)).must_equal %w(2014 2113 2213 2313)
    end
  end

  describe :== do
    it "returns true for identical cycles" do
      _(subject == subject.dup).must_equal true
    end

    it "returns false for different classes" do
      _(subject == 1).must_equal false
    end
  end

  describe :hash do
    it "returns identical hashes for identical cycles" do
      _(subject.hash).must_equal subject.dup.hash
    end

    it "returns different hashes for different cycles" do
      _(subject.hash).wont_equal AIRAC::Cycle.new('2017-12-07').hash
    end
  end
end
