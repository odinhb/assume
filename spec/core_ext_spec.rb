require "assume/core_ext.rb"

RSpec.describe "core_ext" do
  it "allows you to use assume everywhere" do
    assume { true }
  end
end
