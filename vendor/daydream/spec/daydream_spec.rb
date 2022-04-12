# frozen_string_literal: true

RSpec.describe Daydream do
  it "has a version number" do
    expect(Daydream::VERSION).not_to be nil
  end

  it "does something useful" do
    file_name = Dream.image(400, 200, "#008080", 1337)
    expect(File).to exist(file_name)
  end
end
