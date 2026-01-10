# frozen_string_literal: true

require "spec_helper"

RSpec.describe AppPulse::Collector::RequestCollector do
  let(:env) do
    {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/health"
    }
  end

  let(:writer) { double("writer") }

  before do
    allow(AppPulse::Writers).to receive(:fetch).and_return(writer)
    allow(writer).to receive(:write)
    AppPulse.config.sampling_rate = 1.0
  end

  it "collects and writes request data" do
    described_class.collect(
      env: env,
      status: 200,
      duration: 12.3
    )

    expect(writer).to have_received(:write).once
  end

  it "does not raise errors if writer fails" do
    allow(writer).to receive(:write).and_raise(StandardError)

    expect {
      described_class.collect(
        env: env,
        status: 500,
        duration: 10
      )
    }.not_to raise_error
  end
end
