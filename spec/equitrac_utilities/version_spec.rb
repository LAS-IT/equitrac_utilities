RSpec.describe EquitracUtilities::Version do

  it "has a version number" do
    expect(EquitracUtilities::Version::VERSION).not_to be nil
  end

  it "has the correct version number" do
    expect(EquitracUtilities::Version::VERSION).to eq "0.1.1"
  end

end
