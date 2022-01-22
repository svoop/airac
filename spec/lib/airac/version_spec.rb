require_relative '../../spec_helper'

describe AIRAC do
  it "must be defined" do
    _(AIRAC::VERSION).wont_be_nil
  end
end
