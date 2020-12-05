require "assume/refine"

RSpec.describe "refine" do
  it "does nothing by default" do
    expect { assume { true } }
      .to raise_error(NoMethodError)
  end

  describe "using the refinement" do
    using Assumptions

    it "allows you to use assumptions" do
      assume { true }
    end
  end
end
