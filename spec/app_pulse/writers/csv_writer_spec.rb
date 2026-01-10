# frozen_string_literal: true

require "spec_helper"
require "fileutils"
require "csv"

RSpec.describe AppPulse::Writers::CsvWriter do
  let(:output_path) { "tmp/app_pulse_test" }
  let(:writer) { described_class.new }

  before do
    AppPulse.config.output_path = output_path
    FileUtils.rm_rf(output_path)
  end

  after do
    FileUtils.rm_rf(output_path)
  end

  it "writes data to a csv file" do
    data = { foo: "bar", count: 1 }

    writer.write(data)

    files = Dir["#{output_path}/*.csv"]
    expect(files.size).to eq(1)

    content = CSV.read(files.first)
    expect(content.flatten).to include("bar", "1")
  end
end
