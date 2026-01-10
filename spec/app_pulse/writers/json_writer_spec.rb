# frozen_string_literal: true

require "spec_helper"
require "json"

RSpec.describe AppPulse::Writers::JsonWriter do
  let(:output_path) { "tmp/app_pulse_test" }
  let(:writer) { described_class.new }

  before do
    AppPulse.config.output_path = output_path
    FileUtils.rm_rf(output_path)
  end

  after do
    FileUtils.rm_rf(output_path)
  end

  it "writes JSON lines to file" do
    data = { status: 200 }

    writer.write(data)

    file = Dir["#{output_path}/*.json"].first
    content = File.read(file)

    parsed = JSON.parse(content)
    expect(parsed["status"]).to eq(200)
  end
end
