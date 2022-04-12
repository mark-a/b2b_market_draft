# frozen_string_literal: true

require_relative "daydream/version"

require "rutie"

# Ruby wrapper for dream image generation engine
module Daydream
  class Error < StandardError; end

  Rutie.new(:dream).init "Init_dream", __dir__
end
