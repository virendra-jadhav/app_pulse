# frozen_string_literal: true

require "spec_helper"

RSpec.describe AppPulse::Collector::RequestCollector do
  let(:env) do
    {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/health"
    }
  end

  # Fresh writer double per example (prevents call leakage)
  let(:writer) { instance_double("AppPulse::Writers::BaseWriter", write: nil) }

  before do
    allow(AppPulse::Writers).to receive(:fetch).and_return(writer)

    # Reset global config state for each example
    AppPulse.config.sampling_rate = 1.0
    AppPulse.config.slow_threshold_ms = nil
  end

  context "basic behavior" do
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

      expect do
        described_class.collect(
          env: env,
          status: 500,
          duration: 10
        )
      end.not_to raise_error
    end
  end

  context "when slow_threshold_ms is not set" do
    it "collects requests regardless of duration" do
      described_class.collect(
        env: env,
        status: 200,
        duration: 50
      )

      expect(writer).to have_received(:write).once
    end
  end

  context "when slow_threshold_ms is set" do
    before do
      AppPulse.config.slow_threshold_ms = 500
    end

    it "does not collect fast requests" do
      described_class.collect(
        env: env,
        status: 200,
        duration: 100
      )

      expect(writer).not_to have_received(:write)
    end

    it "collects slow requests" do
      described_class.collect(
        env: env,
        status: 200,
        duration: 1000
      )

      expect(writer).to have_received(:write).once
    end
  end
end
