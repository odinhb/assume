# frozen_string_literal: true

RSpec.describe Assume do
  it "has a version number" do
    expect(Assume::VERSION).not_to be nil
  end

  it "is not available by default", :aggregate_failures do
    expect { assume { true } }
      .to raise_error(NoMethodError)
    expect { assumption { true } }
      .to raise_error(NoMethodError)
    expect { handle_broken_assumptions {} }
      .to raise_error(NoMethodError)
  end

  describe "when included" do
    include Assume

    describe "#assume" do
      describe "by default" do
        it "doesn't run the block or raise anything" do
          variable = false
          expect(assume { variable }).to be(nil)
          expect(assume { true }).to be(nil)
          assumption { variable = true }

          expect(variable).to be(false)
        end

        it "raises ArgumentError if not passed a block" do
          expect { assume }
            .to raise_error(ArgumentError)
        end
      end

      describe "when enabled", :aggregate_failures do
        before(:each) do
          Assume.enable!
        end

        it "actually runs the block" do
          variable = true
          assume { variable = false; true }
        end

        it "does nothing and returns nil if the condition is true" do
          expect(assume { true }).to be nil
          expect(assumption { true }).to be nil
        end

        it "raises BrokenAssumption if the condition is false" do
          expect { assume { false } }
            .to raise_error(Assume::BrokenAssumption)
          expect { assumption { false } }
            .to raise_error(Assume::BrokenAssumption)
          expect { assume { true == false } }
            .to raise_error(Assume::BrokenAssumption)
          expect { assumption { "yes" == "no" } }
            .to raise_error(Assume::BrokenAssumption)
        end
      end
    end
  end
end
