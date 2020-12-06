# frozen_string_literal: true

RSpec.describe Assume, :aggregate_failures do
  it "has a version number" do
    expect(Assume::VERSION).not_to be nil
  end

  it "is not available by default" do
    expect { assume { true } }
      .to raise_error(NoMethodError)
    expect { assumption { true } }
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

      describe "when enabled" do
        before(:each) do
          Assume.enabled = true
        end

        it "actually runs the block" do
          variable = true
          assume { variable = false; true }
        end

        it "does nothing and returns nil if the condition is true" do
          expect(assume { true }).to be nil
          expect(assumption { true }).to be nil
          expect(assumption { 5 > 2 }).to be nil
        end

        it "raises BadAssumption if the condition is false" do
          expect { assume { false } }
            .to raise_error(Assume::BadAssumption)
          expect { assumption { false } }
            .to raise_error(Assume::BadAssumption)
          expect { assume { true == false } }
            .to raise_error(Assume::BadAssumption)
          expect { assumption { "yes" == "no" } }
            .to raise_error(Assume::BadAssumption)
        end
      end

      describe "with a custom handler" do
        it "runs the block set as handler" do
          bad = 0
          Assume.handler = proc { bad += 1 }

          assume { false }
          expect(bad).to eq(1)
          assumption { false }
          expect(bad).to eq(2)

          Assume.handler = proc { |result, block|
            expect(result).to be false
            expect(block).to be_a(Proc)
            bad += 1
          }

          assume { false }
          expect(bad).to eq(3)
        end
      end
    end
  end
end
