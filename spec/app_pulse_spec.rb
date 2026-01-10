# frozen_string_literal: true

RSpec.describe AppPulse do
  it "has a version number" do
    expect(AppPulse::VERSION).not_to be nil
  end

  # it "does something useful" do
  #   expect(false).to eq(true)
  # end
  it "allows configuration via block" do
    AppPulse.configure do |config|
      config.sampling_rate = 0.5
    end

    expect(AppPulse.config.sampling_rate).to eq(0.5)
  end
end
